import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/entity/todo_group_entity.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/login/widget/build_list.dart';
import 'package:my_todo/page/login/widget/custom_drawer.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _isDone = false;
  List<MatterData> _list = List();
  TodoGroupEntity _todoGroup;
  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buildList = BuildList(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.dashboard), onPressed: () {}),
        title: Text("${(_isDone) ? '完成' : '待办'}清单"),
        centerTitle: true,
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(icon: Icon(Icons.date_range), onPressed: () {}),
        ],
      ),
      drawer: CustomDrawer(),
      body: IndexedStack(
        children: <Widget>[buildList.buildTodoList(_list)],
        index: 0,
      ),
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
                color: (_isDone == false) ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                if (_isDone == true) {
                  setState(() {
                    _isDone = false;
                  });
                }
              },
            ),
            SizedBox(), //中间位置空出
            IconButton(
              icon: Icon(
                Icons.done_outline,
                color: (_isDone == true) ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                if (_isDone == false) {
                  setState(() {
                    _isDone = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          //悬浮按钮
          child: Icon(Icons.add),
          onPressed: _onAdd),
    );
  }

  _refresh() async {
    Request().getTodoList(false, 4, 1, 4).then((entity) {
      setState(() {
        _todoGroup = entity;
        _list = entity.datas;
      });
    });
  }

  void _onAdd() {}
}
