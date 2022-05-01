import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/presentation/pages/schedule_editor/slider_theme/custom_track_shape.dart';
import 'package:flutter/material.dart';

typedef OnTimeRangeChange = Function(DateTime, DateTime);

class TimeRangeSlider extends StatefulWidget {
  TimeRangeSlider({
    Key key,
    @required this.baseDate,
    @required this.onChanged,
    this.predefinedStartTime,
    this.predefinedEndTime,
    this.disabled = false,
    this.lineColor = Colors.greenAccent,
    this.isPauseSlider = false,
  });

  final DateTime baseDate;
  final OnTimeRangeChange onChanged;

  final DateTime predefinedStartTime;
  final DateTime predefinedEndTime;
  final bool disabled;
  final Color lineColor;
  final bool isPauseSlider;

  @override
  _TimeRangeSliderState createState() => _TimeRangeSliderState();
}

class _TimeRangeSliderState extends State<TimeRangeSlider> {
  final TranslateTime translateTime = TranslateTime();

  DateTime start;
  DateTime end;
  double startValue;
  double endValue;

  double initialStart;
  double initialEnd;

  @override
  void didUpdateWidget(covariant TimeRangeSlider oldWidget) {
    if (widget.baseDate != oldWidget.baseDate) {
      setState(() {
        initCheck();
      });
    } else {}
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    initCheck();
  }

  void initCheck() {
    if (widget.predefinedEndTime == null ||
        widget.predefinedStartTime == null ||
        widget.disabled) {
      startValue = 36;
      endValue = 68;
      if (widget.isPauseSlider) {
        startValue = 48;
        endValue = 52;
      }
    } else {
      startValue = (widget.predefinedStartTime.hour * 4).toDouble();
      endValue = (widget.predefinedEndTime.hour * 4).toDouble();
    }

    start = DateTime(
            widget.baseDate.year, widget.baseDate.month, widget.baseDate.day)
        .add(Duration(minutes: 15 * startValue.toInt()));
    end = DateTime(
            widget.baseDate.year, widget.baseDate.month, widget.baseDate.day)
        .add(Duration(minutes: 15 * endValue.toInt()));
  }

  void onRangeChange(RangeValues values) {
    //setState(() {
    startValue = values.start;
    endValue = values.end;

    start = DateTime(
            widget.baseDate.year, widget.baseDate.month, widget.baseDate.day)
        .add(Duration(minutes: 15 * startValue.toInt()));
    end = DateTime(
            widget.baseDate.year, widget.baseDate.month, widget.baseDate.day)
        .add(Duration(minutes: 15 * endValue.toInt()));
    //});
    widget.onChanged(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: widget.lineColor,
        inactiveTrackColor: widget.lineColor.withOpacity(0.4),
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
        onChanged: widget.disabled ? null : onRangeChange,
        labels: RangeLabels(
          translateTime(time: start),
          translateTime(time: end),
        ),
      ),
    );
  }
}
