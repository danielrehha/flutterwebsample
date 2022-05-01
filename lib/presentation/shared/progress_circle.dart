import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: themeColors[ThemeColor.blue],
      size: 24,
    );
  }
}
