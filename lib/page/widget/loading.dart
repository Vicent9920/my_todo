import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  final bool isFinish;

  Loading(this.isFinish);

  @override
  State<StatefulWidget> createState() {
    return LoadingState();
  }
}

class LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          child: SpinKitCubeGrid(
            size: 50.0,
            color: (widget.isFinish)?Colors.orange:Colors.green,
          ),
          width: 70,
          height: 70,
        ),
        elevation: 5,
      ),
    );
  }
}
