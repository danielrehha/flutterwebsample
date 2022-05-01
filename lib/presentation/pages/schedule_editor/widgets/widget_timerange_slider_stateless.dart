import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/presentation/pages/schedule_editor/slider_theme/custom_track_shape.dart';
import 'package:flutter/material.dart';

typedef OnTimeRangeChange = Function(DateTime, DateTime);

class TimeRangeSliderStateless extends StatelessWidget {
  TimeRangeSliderStateless({
    Key key,
    @required this.baseDate,
    @required this.onChanged,
    this.predefinedStartTime,
    this.predefinedEndTime,
    this.disabled = false,
    this.lineColor = Colors.greenAccent,
    this.isPauseSlider = false,
  }) {
    startValue = predefinedStartTime.hour.toDouble() * 4;
    endValue = predefinedEndTime.hour.toDouble() * 4;
  }
  final TranslateTime translateTime = TranslateTime();

  final DateTime baseDate;
  final OnTimeRangeChange onChanged;

  final DateTime predefinedStartTime;
  final DateTime predefinedEndTime;
  final bool disabled;
  final Color lineColor;
  final bool isPauseSlider;

  double startValue;
  double endValue;

  double initialStart;
  double initialEnd;

  void onRangeChange(RangeValues values) {
    startValue = values.start;
    endValue = values.end;

    DateTime start = DateTime(baseDate.year, baseDate.month, baseDate.day)
        .add(Duration(minutes: 15 * startValue.toInt()));
    DateTime end = DateTime(baseDate.year, baseDate.month, baseDate.day)
        .add(Duration(minutes: 15 * endValue.toInt()));
    onChanged(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: lineColor,
        inactiveTrackColor: lineColor.withOpacity(0.4),
        trackShape: CustomTrackShape(),
        thumbColor: Colors.indigoAccent.shade700,
        disabledThumbColor: Colors.indigoAccent[400],
        thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: 0, disabledThumbRadius: 0),
      ),
      child: RangeSlider(
        min: 24.0,
        max: 92.0,
        divisions: 96,
        values: RangeValues(startValue, endValue),
        onChanged: disabled ? null : onRangeChange,
        labels: RangeLabels(
          translateTime(time: predefinedStartTime),
          translateTime(time: predefinedEndTime),
        ),
      ),
    );
  }
}
