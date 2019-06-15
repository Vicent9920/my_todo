import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';

class DayItem extends StatefulWidget {
  final List<MatterData> data;
  final String date;

  DayItem(this.data, this.date);

  @override
  State<StatefulWidget> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  bool isExpand = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.date);
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(widget.date),
          trailing: IconButton(
            padding: EdgeInsets.all(0.0),
            icon: Icon(
              (isExpand) ? Icons.arrow_forward : Icons.arrow_downward,
              size: 24.0,
            ),
            onPressed: () {
              setState(() {
                isExpand = !isExpand;
              });
            },
          ),
          contentPadding: EdgeInsets.only(left: 14.0, right: 14.0),
        ),
        Divider(),
        buildTodoItem(),
      ],
    );
  }

  Widget buildTodoItem() {
    print(widget.date);
    return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          print("item的下标：${index}");
          final total = widget.data.length * 2;
          if (index <= total) {
            if (index.isOdd) return Divider();
            final i = index % 2;
            if (i < widget.data.length) {
              var item = widget.data[i];
              print(item.title);
              return ListTile(
                contentPadding: EdgeInsets.only(left: 2.0, right: 14.0),
                leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.touch_app,
                      size: 24.0,
                    ),
                    onPressed: () {
                      finish(item, i);
                    }),
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  item.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.delete_forever,
                      size: 24.0,
                    ),
                    onPressed: () {
                      delete(item, index);
                    }),
                onTap: () {
                  openDetails(item);
                },
              );
            }
          }
        });
  }

  void finish(MatterData item, int index) {}

  void delete(MatterData item, int index) {}

  void openDetails(MatterData item) {}
}
