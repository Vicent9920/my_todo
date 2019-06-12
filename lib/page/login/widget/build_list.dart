import 'package:flutter/material.dart';
import 'package:my_todo/entity/matter_data_entity.dart';

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
    List<Map<String, bool>> dateList = List();

    for (var i in list) {
      for (Map<String, bool> m in dateList) {
        if (m.keys.contains(i.dateStr)) {
          bool isEnd = false;
          for (var matters in listData) {
            if (matters.keys.contains(i.dateStr)) {
              matters[i.dateStr].add(i);
              isEnd = true;
              break;
            }
          }
          if (isEnd) break;
        }
      }
      var mapDate = Map();
      mapDate[i.dateStr] = false;
      dateList.add(mapDate);
      var ms = List<MatterData>();
      ms.add(i);
      var mapData = Map();
      mapData[i.dateStr] = ms;
      listData.add(mapData);

    }

    return ListView.builder(itemBuilder: (context, index) {
      final total = dateList.length * 2;
      // TODO 以日期为Item绘制列表
    });
  }
}
