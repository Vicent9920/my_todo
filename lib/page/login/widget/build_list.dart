import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/page/login/widget/day_items.dart';

class BuildList {
  final BuildContext context;

  BuildList(this.context);

  Widget buildTodoList(List<MatterData> list) {
    if (list.length == 0) {
      return Center(
        child: Text(
          "目前暂无数据",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    List<Map<String, List<MatterData>>> listData = List();

    for (var i in list) {
      bool isContains = false;
      for (Map<String, List<MatterData>> m in listData) {
        if (m.keys.contains(i.dateStr)) {
          m[i.dateStr].add(i);
          isContains = true;
          break;
        }
      }
      if (!isContains) {
        var ms = List<MatterData>();
        ms.add(i);
        var mapData = Map();
        mapData[i.dateStr] = ms;
        listData.add(mapData);
      }
    }

    return ListView.builder(itemBuilder: (context, index) {
      final total = listData.length * 2;
      if (index <= total) {
        if (index.isOdd) return Divider();
        final i = index ~/ 2;
        if (i < listData.length) {
          Map<String, List<MatterData>> map = listData[i];
          return DayItem(map.values.toList()[0], map.keys.toList()[0]);
        }
      }
    });
  }

  Widget getTodoDay(Map<String, List<MatterData>> days) {
    bool isExpand = false;
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 12.0,
              child: Text(days.keys.toList()[0]),
            ),
            Positioned(
              right: 14.0,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_drop_up,
                  color: Colors.black54,
                ),
                onPressed: () {
                  isExpand = !isExpand;
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
