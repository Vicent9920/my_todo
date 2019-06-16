import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';
import 'package:my_todo/page/widget/day_items.dart';

class BuildList {
  final BuildContext context;

  BuildList(this.context);

  Widget buildTodoList(List<MatterData> list,bool isFinish) {
    if (list.length == 0) {
      return Center(
        child: Text(
          "目前暂无数据",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    Map<String, List<MatterData>> days = Map();
    for (var i in list) {
      if (days.keys.contains(i.dateStr)) {
        days[i.dateStr].add(i);
      } else {
        var ms = List<MatterData>();
        ms.add(i);
        days[i.dateStr] = ms;
      }
    }
    return ListView.builder(
      shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final total = days.length;
          if (index <= total) {
            if (index < days.length) {
            return DayItem(days.values.toList()[index], days.keys.toList()[index],isFinish);
            }
          }
        });


  }
}
