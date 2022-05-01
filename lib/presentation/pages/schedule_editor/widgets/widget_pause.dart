import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/models/model_workpause.dart';
import 'package:flutter/material.dart';

class PauseWidget extends StatefulWidget {
  PauseWidget({
    Key key,
    @required this.pause,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  }) : super(key: key);

  WorkPauseModel pause;
  final Color backgroundColor;
  final Color textColor;

  @override
  _PauseWidgetState createState() => _PauseWidgetState();
}

class _PauseWidgetState extends State<PauseWidget> {
  final TranslateTime translateTime = TranslateTime();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
    );
  }
}
