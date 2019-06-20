import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
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
  String date;

  @override
  void initState() {
    status = getStatus();
    date = getDate();
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: '必填',
                ),
              ),
              Divider(),
              Text(
                '计划内容：',
                style: TextStyle(fontSize: 16, color: Color(0x99000000)),
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                minLines: 4,
                maxLength: 240,
                maxLines: 10,
                maxLengthEnforced: true,
                enabled: status != 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: '必填',
                ),
              ),
              Divider(),
              SizedBox(height: 8,),
              Row(
                children: <Widget>[
                  Text(
                    '开始时间：',
                    style: TextStyle(fontSize: 16),
                  ),

                  Expanded(

                    child: Container(
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 16,
                          decorationStyle: TextDecorationStyle.solid
                        ),
                        textAlign: TextAlign.end,
                      ),
                    )
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.date_range,
                    ),
                    onTap: _showDialog,
                  )
                ],
              ),
              SizedBox(height: 8,),
              Divider(),
              SizedBox(height: 8,),
              Row(
                children: <Widget>[
                  Text(
                    '计划类型：',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(

                    child: GestureDetector(
                      child: Text(
                        getType(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onTap: showPop,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    child: Container(
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: showPop,
                  )
                ],
              ),
              SizedBox(height: 8,),
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

  _save() {}

  _update() {}

  _delete() {}

  _showDialog() {
    if (status != 2) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(
            CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: str2Date(date),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  date = formatDate(newDateTime);
                });
              },
            ),
          );
        },
      );
    }
  }
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
  showPop() {
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
    _type = index;
    setState(() {});
    Navigator.of(context).pop();
  }

  int getStatus() {
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

  String getDate() {
    if (status == 0) {
      return '请选择';
    } else {
      return _matterData.dateStr;
    }
  }

  String getType() {
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
  
}
