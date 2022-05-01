import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';

class ApplicationWidgetContainer extends StatelessWidget {
  const ApplicationWidgetContainer({
    Key key,
    @required this.child,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.verticalInnerPadding = 10,
    this.horizontalInnerPadding = 10,
    this.height,
  }) : super(key: key);

  final Widget child;
  final double horizontalPadding;
  final double verticalPadding;
  final double height;
  final double horizontalInnerPadding;
  final double verticalInnerPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [inputBoxShadow]),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalInnerPadding,
            vertical: verticalInnerPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
