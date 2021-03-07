import 'package:flutter/material.dart';

class ProjectCircularProgress extends StatelessWidget {
  final Color customColor;
  const ProjectCircularProgress({
    Key key,
    this.customColor = Colors.white70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          color: customColor, //default set or custom passed in
          child: Container(
            margin: EdgeInsets.only(top: 100),
            // width: double.infinity,
            // height: 100,
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator.adaptive(),
          ));
    });
  }
}
