import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/entity/todo_group_entity.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/widget/build_list.dart';
import 'package:my_todo/page/widget/custom_drawer.dart';
import 'package:my_todo/page/widget/loading.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _isDone = false;
  List<MatterData> _list = List();
  var _themeColor = [Colors.orange, Colors.green];
  int status = 0;
  TodoGroupEntity _todoGroup;

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
              child: Image.asset('res/images/ic_screening.png',width: 24,height: 24,),
            ),

            onTap: (){

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
      });
      _refresh();
    }
  }


  Widget _buildBody() {
    switch (status) {
      case 0:
        return Loading(_isDone);
      case 1:
        return BuildList(context).buildTodoList(_list, _isDone);

    }
  }

  _refresh() async {
    Request().getTodoList(_isDone, 4, 1, 4).then((entity) {
      print(entity.total);
      _list.clear();
      setState(() {
        status = 1;
        _todoGroup = entity;
        _list.addAll(entity.datas);
      });
    });
  }

  void _onAdd() {}
}
