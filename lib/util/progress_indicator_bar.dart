import 'package:flutter/material.dart';

class ProgressIndicatorBar extends StatefulWidget {
  @override
  _ProgressIndicatorBarState createState() => new _ProgressIndicatorBarState();
}

class _ProgressIndicatorBarState extends State<ProgressIndicatorBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LinearProgressIndicator(
      value: animation.value,
    ));
  }
}
