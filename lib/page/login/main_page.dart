
import 'package:flutter/material.dart';
import 'package:my_todo/page/login/widget/custom_drawer.dart';

class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MainPageState();

}
class _MainPageState extends State<MainPage>{
  String title = "代办清单";
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.storage), onPressed: (){}),
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          //均分底部导航栏横向空间
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.border_color)),
            SizedBox(), //中间位置空出
            IconButton(icon: Icon(Icons.done_outline)),
          ],
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton( //悬浮按钮
          child: Icon(Icons.add),
          onPressed:_onAdd
      ),
    );
  }

  void _onAdd() {

  }
}