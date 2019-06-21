import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/widget/toast.dart';
import 'package:my_todo/util/date_util.dart';
const double _kPickerSheetHeight = 216.0;
const double _kPickerItemHeight = 32.0;
class Plan extends StatefulWidget {
  final MatterData matterData;

  Plan(this.matterData);

  @override
  State<StatefulWidget> createState() => _Plan(matterData);
}

class _Plan extends State<Plan> {
  MatterData _matterData;

  _Plan(this._matterData);

  int status;
  int _type = 0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String date = formatDate(DateTime.now());

  @override
  void initState() {
    status = _getStatus();
    date = _getDate();
    if (status != 0) {
      _titleController.text = _matterData.title;
      _contentController.text = _matterData.content;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // https://github.com/alibaba/flutter-go IOS 效果页面
    return Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
          centerTitle: true,
          actions: <Widget>[
            (status == 0)
                ? IconButton(icon: Icon(Icons.save_alt), onPressed: _save)
                : null
          ],
          backgroundColor: (status == 2)?Colors.orange:Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
          child: ListView(
            children: <Widget>[
              Text(
                '计划主题：',
                style: TextStyle(fontSize: 16, color: Color(0x99000000)),
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                maxLength: 24,
                maxLengthEnforced: true,
                enabled: status != 2,
                textInputAction: TextInputAction.next,
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: '必填',
                  contentPadding: EdgeInsets.all(6.0)
                ),
              ),
              Text(
                '计划内容：',
                style: TextStyle(fontSize: 16, color: Color(0x99000000)),
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                minLines: 4,
                maxLength: 360,
                maxLines: 20,
                maxLengthEnforced: true,
                enabled: status != 2,
                controller: _contentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: '必填',
                    contentPadding: EdgeInsets.all(6.0)
                ),
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Text(
                    '开始时间：',
                    style: TextStyle(fontSize: 16),
                  ),

                  Expanded(

                    child: GestureDetector(
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 16,
                          decorationStyle: TextDecorationStyle.solid
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onTap: (){
                        _selectDate(context);
                      },
                    )
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.date_range,
                    ),
                    onPressed: (){
                      _selectDate(context);
                    },
                  )
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Text(
                    '计划类型：',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(

                    child: GestureDetector(
                      child: Text(
                        _getType(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onTap: _showPop,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: _showPop,
                  )
                ],
              ),
              Divider(),
              SizedBox(
                height: 24,
              ),
              Offstage(
                offstage: status != 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.green,
                          highlightColor: Colors.lightGreen,
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("修改计划"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: _update,
                        ),
                        RaisedButton(
                          color: Colors.deepOrange,
                          highlightColor: Colors.deepOrange,
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("删除计划"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: _delete,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: status != 1,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: RaisedButton(
                        color: Colors.deepOrange,
                        highlightColor: Colors.deepOrange,
                        colorBrightness: Brightness.dark,
                        splashColor: Colors.grey,
                        child: Text("删除计划"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: _delete,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _save() {

    if(_titleController.text.trim().isEmpty){
      return Toast.toast(context, '请填写计划主题');
    }
    if(_contentController.text.trim().isEmpty){
      return Toast.toast(context, '请填写计划内容');
    }
    Request().addTodo(_titleController.text, _contentController.text, date, _type).then((result){
      Toast.toast(context, '保存成功');
      Navigator.pop(context, result);
    }).catchError((error){
      print(error);
//      Toast.toast(context, '保存失败');
    });
  }

  _update() {}

  _delete() {}

  Future<void> _selectDate(BuildContext context) async {
    if (status != 2){
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _initialDate(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050, 4, 15),);
      if (picked != null && picked != str2Date(date)) {
        setState(() {
          date = formatDate(picked);
        });

      }
    }

  }
  _showPop() {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
  }

  _onItemPress(int index) {
    setState(() {
      _type = index;
    });
    Navigator.of(context).pop();
  }

  int _getStatus() {
    if (_matterData == null) {
      return 0;
    } else if (_matterData.completeDateStr == null) {
      return 1;
    } else {
      return 2;
    }
  }

  String _getTitle() {
    switch (status) {
      case 0:
        return '添加计划';
      case 1:
        return '编辑计划';
      default:
        return '计划详情';
    }
  }

  String _getDate() {
    if (status == 0) {
      return date;
    } else {
      return _matterData.dateStr;
    }
  }

  String _getType() {
    switch (_type) {
      case 1:
        return '工作';
      case 2:
        return '生活';
      case 3:
        return '娱乐';
      default:
        return '全部';
    }
  }

  DateTime _initialDate() {
    return (date == '请选择')?DateTime.now().add(Duration(days: 1)):str2Date(date);
  }
  
}
