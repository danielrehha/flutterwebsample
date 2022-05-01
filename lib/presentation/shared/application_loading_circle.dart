import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

enum IndicatorType { Circle, JumpingDots }

class ApplicationLoadingIndicator extends StatelessWidget {
  const ApplicationLoadingIndicator({Key key, this.type = IndicatorType.Circle, this.color = const Color(0xff085cfd)})
      : super(key: key);

  final IndicatorType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getType(),
    );
  }

  Widget getType() {
    switch (type) {
      case IndicatorType.Circle:
        return CircularProgressIndicator(color: color,);
      case IndicatorType.JumpingDots:
        return JumpingDotsProgressIndicator(color: color,fontSize: 36,dotSpacing: 2,);
      default:
        return CircularProgressIndicator();
    }
  }
}
