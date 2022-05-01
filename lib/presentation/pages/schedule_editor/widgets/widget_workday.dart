import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/models/model_workday.dart';
import 'package:allbert_cms/data/models/model_workpause.dart';
import 'package:allbert_cms/presentation/pages/schedule_editor/widgets/widget_timerange_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:uuid/uuid.dart';

typedef OnUpdateWorkDay = Function(WorkDayModel);

class WorkDayWidget extends StatefulWidget {
  WorkDayWidget({Key key, @required this.workday, @required this.onUpdate});

  final WorkDayModel workday;
  final OnUpdateWorkDay onUpdate;

  @override
  _WorkDayWidgetState createState() => _WorkDayWidgetState();
}

class _WorkDayWidgetState extends State<WorkDayWidget> {
  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();

  WorkDayModel workday;

  bool isPause;

  @override
  void initState() {
    super.initState();

    initCheck();
  }

  @override
  void didUpdateWidget(covariant WorkDayWidget oldWidget) {
    if (widget.workday != oldWidget.workday) {
      setState(() {
        initCheck();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void initCheck() {
    isPause = widget.workday.pauseList.isNotEmpty;
    workday = widget.workday;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                  ),
                ),
                width: 130,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Feather.calendar,
                        size: 20,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        translateDate.numeric(
                          widget.workday.date,
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo.shade600,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                  ),
                ),
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "${translateTime(time: widget.workday.startTime)}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  //width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                  ),
                  child: TimeRangeSlider(
                    baseDate: widget.workday.date,
                    predefinedStartTime: widget.workday.startTime,
                    predefinedEndTime: widget.workday.endTime,
                    onChanged: (start, end) {
                      setState(() {
                        workday = widget.workday.copyWith(startTime: start);
                        workday = workday.copyWith(endTime: end);

                        widget.onUpdate(workday);
                      });
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo.shade700,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "${translateTime(time: widget.workday.endTime)}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          //===========================================//===========================================//===========================================
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                width: 130,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: Checkbox(
                            value: isPause,
                            onChanged: (value) {
                              setState(() {
                                if (!value) {
                                  widget.workday.pauseList.clear();
                                } else {
                                  widget.workday.pauseList.clear();

                                  widget.workday.pauseList.insert(
                                    0,
                                    WorkPauseModel(
                                      id: Uuid().v4(),
                                      workdayId: widget.workday.id,
                                      index: 0,
                                      date: widget.workday.date,
                                      startTime: DateTime(
                                        widget.workday.startTime.year,
                                        widget.workday.startTime.month,
                                        widget.workday.startTime.day,
                                        12,
                                      ),
                                      endTime: DateTime(
                                        widget.workday.startTime.year,
                                        widget.workday.startTime.month,
                                        widget.workday.startTime.day,
                                        13,
                                      ),
                                    ),
                                  );
                                }
                                isPause = value;
                              });
                            }),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text("Szünet"),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isPause ? Colors.indigo.shade600 : Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                ),
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    isPause
                        ? "${translateTime(time: workday.pauseList[0].startTime)}"
                        : "--:--",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  //width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                  ),
                  child: TimeRangeSlider(
                    lineColor: Colors.amber[400],
                    disabled: !isPause,
                    isPauseSlider: true,
                    baseDate: widget.workday.date,
                    predefinedStartTime:
                        isPause ? widget.workday.pauseList[0].startTime : null,
                    predefinedEndTime:
                        isPause ? widget.workday.pauseList[0].endTime : null,
                    onChanged: (start, end) {
                      List<WorkPauseModel> pauseList = workday.pauseList;
                      pauseList[0] = pauseList[0].copyWith(startTime: start);
                      pauseList[0] = pauseList[0].copyWith(endTime: end);
                      workday = widget.workday.copyWith(pauseList: pauseList);

                      widget.onUpdate(workday);

                      setState(() {});
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isPause ? Colors.indigo.shade700 : Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    isPause
                        ? "${translateTime(time: widget.workday.pauseList[0].endTime)}"
                        : "--:--",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
