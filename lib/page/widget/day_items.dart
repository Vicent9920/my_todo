import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/net/request.dart';
import 'package:my_todo/page/widget/toast.dart';

typedef ItemClickCallback = void Function(MatterData data);
typedef DeleteClickCallback = void Function(String date);

// ignore: must_be_immutable
class DayItem extends StatefulWidget {
  final List<MatterData> data;
  final String date;
  final bool isFinished;
  final ItemClickCallback itemClickListener;
  final DeleteClickCallback deleteClickCallback;

  DayItem(this.data, this.date, this.isFinished, this.itemClickListener,this.deleteClickCallback);

  @override
  State<StatefulWidget> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  bool isExpand = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(6),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.date,
                  style: TextStyle(
                      color:
                          (widget.isFinished) ? Colors.orange : Colors.green),
                ),
                GestureDetector(
                  child: Icon(
                    (isExpand) ? Icons.arrow_downward : Icons.arrow_forward,
                  ),
                  onTap: () {
                    setState(() {
                      isExpand = !isExpand;
                    });
                  },
                )
              ],
            ),
          ),
          Offstage(
            offstage: !isExpand,
            child: Column(
              children: <Widget>[
                Divider(
                  color: Colors.blueGrey,
                ),
                (widget.isFinished) ? _buildFinishItem() : _buildTodoItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoItem() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final total = widget.data.length * 2 - 1;

          if (index <= total) {
            if (index == total)
              return SizedBox(
                height: 6,
              );
            if (index.isOdd)
              return Divider(
                color: Colors.blueGrey,
                indent: 14,
              );
            final i = index ~/ 2;
            if (i < widget.data.length) {
              var item = widget.data[i];
              return Padding(
                padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('res/images/ic_finished.png'),
                      ),
                      onTap: () {
                        _finish(item, index, true);
                      },
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            ),
                            onTap: () {
                              widget.itemClickListener(item);
                            },
                          ),
                          Text(
                            (item.content == null) ? '无' : item.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.delete_forever,
                      ),
                      onTap: () {
                        _delete(item, index);
                      },
                    )
                  ],
                ),
              );
            }
          }
        });
  }

  Widget _buildFinishItem() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final total = widget.data.length * 2 - 1;
          if (index <= total) {
            if (index == total)
              return SizedBox(
                height: 6,
              );
            if (index.isOdd)
              return Divider(
                color: Colors.blueGrey,
                indent: 14,
              );
            final i = index ~/ 2;
            if (i < widget.data.length) {
              var item = widget.data[i];
              return Padding(
                padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Image.asset('res/images/ic_return.png'),
                      ),
                      onTap: () {
                        _finish(item, index, false);
                      },
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).textTheme.body1.color),
                          ),
                          Text(
                            (item.content == null) ? '无' : item.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          RichText(
                            text: TextSpan(text: '', children: <TextSpan>[
                              TextSpan(
                                  text: '完成时间',
                                  style: TextStyle(color: Colors.grey)),
                              TextSpan(text: ' '),
                              TextSpan(
                                  text: item.completeDateStr,
                                  style: TextStyle(color: Colors.red))
                            ]),
                          )
                        ],
                      ),
                      onTap: () {
                        widget.itemClickListener(item);
                      },
                    )),
                    GestureDetector(
                      child: Icon(
                        Icons.delete_forever,
                      ),
                      onTap: () {
                        _delete(item, index);
                      },
                    )
                  ],
                ),
              );
            }
          }
        });
  }

  void _finish(MatterData item, int index, bool isFinish) {
    Request().updateMatterStatus(item.id, isFinish).then((result) {
      Toast.toast(context, "更新成功");
      setState(() {
        widget.data.remove(item);
      });
    }).catchError((error) {
      print(error);
      Toast.toast(context, "更新失败");
    });
  }

  void _delete(MatterData item, int index) async {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('提示'),
            content: Text('是否确认删除？\n删除后不可恢复！'),
            actions: <Widget>[
              new CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消')),
              new CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Request().deleteMatter(item.id).then((result) {

                      if(index == 0 && widget.data.length == 1){
                        widget.deleteClickCallback(widget.date);
                        return;
                      }
                      setState(() {
                        widget.data.removeAt(index);
                      });
                      Toast.toast(context, "删除成功");
                    }).catchError((error) {
                      print(error);
                      Toast.toast(context, "删除失败");
                    });
                  },
                  child: Text('确认')),
            ],
          );
        });
  }
}
