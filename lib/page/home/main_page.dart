import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/plan/plan.dart';
import 'package:my_todo/page/widget/build_list.dart';
import 'package:my_todo/page/widget/custom_drawer.dart';
import 'package:my_todo/page/widget/loading.dart';
import 'package:my_todo/page/widget/pullrefresh/mulite_page_fresh.dart';
import 'package:my_todo/page/widget/toast.dart';
import 'package:my_todo/util/sp_store_util.dart';

typedef void ItemOnPressed();

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 是否执行
  var _isDone = false;

  // 计划列表
  List<MatterData> _list = List();

  // 主题颜色
  var _themeColor = [Colors.orange, Colors.green];

  // 页面状态 0 加载  1 数据  2 空页面 3 异常
  int status = 0;

  // 当前的计划类型 0 全部 1 工作  2 生活  3 娱乐
  int _currentType = 0;
  int _currentPage = 1;
  bool _loadMoreEnable = true;

  @override
  void initState() {
    _refresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.dashboard), onPressed: () {}),
        title: Text("${(_isDone) ? '完成' : '待办'}清单"),
        centerTitle: true,
        actions: <Widget>[
          //导航栏右侧菜单
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 14.0),
              child: Image.asset(
                'res/images/ic_screening.png',
                width: 24,
                height: 24,
              ),
            ),
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      title: Text(
                        '请选择计划类型',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      cancelButton: CupertinoActionSheetAction(
                        child: Text(
                          '取消',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {},
                      ),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text('工作'),
                          onPressed: () {
                            _onItemPress(1);
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text('生活'),
                          onPressed: () {
                            _onItemPress(2);
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text('娱乐'),
                          onPressed: () {
                            _onItemPress(3);
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text('全部'),
                          onPressed: () {
                            _onItemPress(0);
                          },
                        )
                      ],
                    );
                  });
            },
          )
        ],
        backgroundColor: (_isDone) ? _themeColor[0] : _themeColor[1],
      ),
      drawer: CustomDrawer(),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          //均分底部导航栏横向空间
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.border_color,
                color: (_isDone == false) ? _themeColor[1] : Colors.grey,
              ),
              onPressed: () {
                _changeStatus(true);
              },
            ),
            SizedBox(), //中间位置空出
            IconButton(
              icon: Icon(
                Icons.done_outline,
                color: (_isDone == true) ? _themeColor[0] : Colors.grey,
              ),
              onPressed: () {
                _changeStatus(false);
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: (_isDone) ? _themeColor[0] : _themeColor[1],
          //悬浮按钮
          child: Icon(Icons.add),
          onPressed: _onAdd),
    );
  }

  void _changeStatus(bool current) {
    if (_isDone == current) {
      setState(() {
        _isDone = !current;
        status = 0;
        _currentPage = 1;
      });
      _refresh();
    }
  }

  // ignore: missing_return
  Widget _buildBody() {
    switch (status) {
      case 0:
        return Loading(_isDone);
      case 1:
        return MultiPageFresh(
            _loadMore, BuildList(context).buildTodoList(_list, _isDone));
      case 2:
        return Center(
          child: Text(
            "目前暂无数据",
            style: TextStyle(fontSize: 18),
          ),
        );
    }
  }

  void _onItemPress(int type) {
    _currentType = type;
    SpUtils.setInt(SpUtils.CURRENT_INDEX, _currentType).then((result) {
      if (result) {
        Toast.toast(context, "修改成功");
        setState(() {
          status = 0;
          _refresh();
        });
      }
    });
    Navigator.of(context).pop();
  }

  _refresh() async {
    SpUtils.getInt(SpUtils.CURRENT_INDEX).then((type) {
      _currentType = type;
      return Request().getTodoList(_isDone, _currentType, _currentPage, 4);
    }).then((entity) {
      _list.clear();
      _list.addAll(entity.datas);
      status = (_list.length > 0) ? 1 : 2;
      setState(() {
        _loadMoreEnable = entity.pageCount != _currentPage;
      });
    });
  }

  _loadMore() async {
    if (_loadMoreEnable) {
      _currentPage++;
      Request()
          .getTodoList(_isDone, _currentType, _currentPage, 4)
          .then((entity) {
        setState(() {
          _list.addAll(entity.datas);
          _loadMoreEnable = entity.pageCount != _currentPage;
        });
      });
    }
  }

  void _onAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Plan(null);
    })).then((result) {
      setState(() {
        status = 0;
        _currentPage = 1;
      });
      _refresh();
    });
  }
}
