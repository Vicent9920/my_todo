import 'package:flutter/material.dart';
import 'package:my_todo/page/widget/pullrefresh/behavior.dart';
import 'package:my_todo/page/widget/pullrefresh/pullrefresh.dart';

class MultiPageFresh extends StatefulWidget {
  //加载更多回调
  final OnLoadmore onLoadMore;
  final ScrollView scrollView;

  MultiPageFresh(this.onLoadMore, this.scrollView);

  @override
  State<StatefulWidget> createState() => _MultiPageFresh();
}

class _MultiPageFresh extends State<MultiPageFresh> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          checkStatus(notification);
        }
        return true;
      },
      child: ScrollConfiguration(
        behavior: RefreshBehavior(),
        child: new CustomScrollView(
          slivers: new List.from(widget.scrollView.buildSlivers(context),
              growable: true),
        ),
      ),
    );
  }

  void checkStatus(ScrollEndNotification notification) async {
    double progress =
        notification.metrics.pixels / notification.metrics.maxScrollExtent;
    print("${(progress * 100).toInt()}%");
    if ((progress * 100).toInt() == 100) {
      await widget.onLoadMore();
    }
  }
}
