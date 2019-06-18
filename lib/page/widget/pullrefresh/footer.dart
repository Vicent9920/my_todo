import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 底部栏状态
enum RefreshFooterStatus {
  NO_LOAD,
  LOAD_READY,
  LOADING,
  LOADED,
}

/// 上拉加载视图抽象类
/// 自定义视图需要实现此类中的方法
abstract class RefreshFooter extends StatefulWidget {
  // 触发加载的高度
  final double loadHeight;

  // 是否浮动
  final bool isFloat;

  // 完成延时时间(ms)
  final int finishDelay;

  // 获取键
  GlobalKey<RefreshFooterState> getKey() {
    return this.key;
  }

  // 构造函数
  RefreshFooter(
      {@required GlobalKey<RefreshFooterState> key,
      this.loadHeight: 70.0,
      this.isFloat: false,
      this.finishDelay: 1000})
      : super(key: key) {
    assert(this.key != null);
  }
}

abstract class RefreshFooterState<T extends RefreshFooter> extends State<T> {
  // 底部栏状态
  RefreshFooterStatus refreshFooterStatus = RefreshFooterStatus.NO_LOAD;

  // 高度
  double height = 0.0;

  // 更新视图高度
  @mustCallSuper
  void updateHeight(double newHeight) {
    setState(() {
      height = newHeight;
    });
  }

  // 回调开始加载方法
  @mustCallSuper
  Future onLoadStart() async {
    refreshFooterStatus = RefreshFooterStatus.NO_LOAD;
  }

  // 回调准备加载方法
  @mustCallSuper
  Future onLoadReady() async {
    refreshFooterStatus = RefreshFooterStatus.LOAD_READY;
  }

  // 回调开始加载方法
  @mustCallSuper
  Future onLoading() async {
    refreshFooterStatus = RefreshFooterStatus.LOADING;
  }

  // 回调加载完成方法
  @mustCallSuper
  Future onLoaded() async {
    refreshFooterStatus = RefreshFooterStatus.LOADED;
  }

  // 回调没有更多数据方法
  @mustCallSuper
  Future onNoMore() async {
    refreshFooterStatus = RefreshFooterStatus.LOADED;
  }

  // 回调加载恢复方法
  @mustCallSuper
  Future onLoadRestore() async {
    refreshFooterStatus = RefreshFooterStatus.NO_LOAD;
  }

  // 回调加载结束方法
  @mustCallSuper
  Future onLoadEnd() async {
    refreshFooterStatus = RefreshFooterStatus.NO_LOAD;
  }
}

/// 经典(默认)底部视图
class ClassicsFooter extends RefreshFooter {
  // 提示加载文字
  final String loadText;

  // 准备加载文字
  final String loadReadyText;

  // 正在加载文字
  final String loadingText;

  // 没有更多文字
  final String noMoreText;

  // 刷新完成文字
  final String loadedText;

  // 触发加载的高度
  final double loadHeight;

  // 是否浮动
  final bool isFloat;

  // 显示额外信息(默认为时间)
  final bool showMore;

  // 更多信息
  final String moreInfo;

  // 构造函数
  ClassicsFooter(
      {GlobalKey<RefreshFooterState> key,
      this.loadText: "上拉加载",
      this.loadReadyText: "准备加载",
      this.loadingText: "正在加载",
      this.loadedText: "完成",
      this.noMoreText: "没有更多数据",
      this.loadHeight: 70.0,
      this.isFloat: false,
      this.showMore: false,
      this.moreInfo: "Loaded at %T"})
      : super(key: key, loadHeight: loadHeight, isFloat: isFloat);

  @override
  ClassicsFooterState createState() => ClassicsFooterState();
}

class ClassicsFooterState extends RefreshFooterState<ClassicsFooter> {
  // 显示的文字
  String _showText;

  // 更新时间
  DateTime _dateTime;

  // 初始化操作
  @override
  void initState() {
    super.initState();
    _showText = widget.loadText;
    _dateTime = DateTime.now();
  }

  // 准备加载回调
  @override
  Future onLoadReady() async {
    super.onLoadReady();
    setState(() {
      _showText = widget.loadReadyText;
    });
  }

  // 正在加载回调
  @override
  Future onLoading() async {
    super.onLoading();
    setState(() {
      _showText = widget.loadingText;
    });
  }

  // 加载完成回调
  @override
  Future onLoaded() async {
    super.onLoaded();
    setState(() {
      _dateTime = DateTime.now();
      _showText = widget.loadedText;
    });
  }

  // 没有更多数据回调
  @override
  Future onNoMore() async {
    super.onNoMore();
    setState(() {
      _dateTime = DateTime.now();
      _showText = widget.noMoreText;
    });
  }

  // 加载恢复回调
  @override
  Future onLoadRestore() async {
    super.onLoadRestore();
    setState(() {
      _showText = widget.loadText;
    });
  }

  // 加载结束回调
  @override
  Future onLoadEnd() async {
    super.onLoadEnd();
    setState(() {
      _showText = widget.loadText;
    });
  }

  // 获取更多信息
  String _getMoreInfo() {
    String fillChar = _dateTime.minute < 10 ? "0" : "";
    return widget.moreInfo
        .replaceAll("%T", "${_dateTime.hour}:$fillChar${_dateTime.minute}");
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      //上拉加载布局
      color: Theme.of(context).primaryColor,
      height: this.height,
      child: SingleChildScrollView(
          child: Container(
        height: this.height > 45.0 ? this.height : 45.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: new Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    this.refreshFooterStatus == RefreshFooterStatus.NO_LOAD
                        ? Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          )
                        : Container(),
                    this.refreshFooterStatus == RefreshFooterStatus.LOADING
                        ? new Align(
                            alignment: Alignment.centerLeft,
                            child: new Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          )
                        : Container(),
                    this.refreshFooterStatus == RefreshFooterStatus.LOAD_READY
                        ? Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          )
                        : Container(),
                    this.refreshFooterStatus == RefreshFooterStatus.LOADED
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Container(
                width: 150.0,
                height: double.infinity,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      _showText,
                      style: new TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    Container(
                      height: 2.0,
                    ),
                    widget.showMore
                        ? new Text(
                            _getMoreInfo(),
                            style: new TextStyle(
                                color: Colors.white, fontSize: 12.0),
                          )
                        : Container(),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      )),
    );
  }
}
