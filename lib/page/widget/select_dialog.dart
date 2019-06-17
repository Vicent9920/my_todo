
import 'package:flutter/material.dart';
import 'package:my_todo/util/sp_store_util.dart';

class SelectDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectDialogState();
  }

}
class _SelectDialogState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  int index = 0;
  TabController _tabController;
  @override
  void initState() {
    _tabController =
    new TabController(initialIndex: index, length: 4, vsync: this);
    _getCurrentIndex();
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return null;
  }

  void _getCurrentIndex() async {
    int position = await SpUtils.getInt(SpUtils.CURRENT_INDEX);
    if(position!=index){
      setState(() {
        index = position;
      });
    }
  }

}