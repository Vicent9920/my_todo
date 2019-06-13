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
  List<MatterData> _data;

  @override
  void initState() {
    _data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 12.0,
              child: Text(widget.date),
            ),
            Positioned(
              right: 14.0,
              child: IconButton(
                icon: Icon(
                  (isExpand) ? Icons.arrow_forward : Icons.arrow_downward,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    isExpand = !isExpand;
                  });
                },
              ),
            )
          ],
        ),
        buildTodoItem(),
      ],
    );
  }

  Widget buildTodoItem() {
    return ListView.builder(itemBuilder: (context, index) {
      final total = _data.length * 2 + 1;
      if (index > 1 && index <= total) {
        if (index.isOdd) return Divider();
        final i = index % 2;
        if (i < _data.length) {
          var item = _data[i];
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 14.0,
                top: 14.0,
                child: IconButton(
                    icon: Icon(Icons.touch_app),
                    onPressed: () {
                      finish(item, i);
                    }),
              ),
              Positioned(
                top: 14.0,
                right: 14.0,
                child: IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () {
                      delete(item, index);
                    }),
              ),
              Positioned(
                left: 52,
                top: 14,
                right: 54,
                bottom: 14,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        item.title,
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        openDetails(item);
                      },
                    ),
                    Text(
                      item.content,
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ],
          );
        }
      }
    });
  }

  void finish(MatterData item, int index) {}

  void delete(MatterData item, int index) {}

  void openDetails(MatterData item) {}
}
