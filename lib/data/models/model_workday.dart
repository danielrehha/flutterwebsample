import 'package:allbert_cms/domain/entities/entity_workday.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'model_workpause.dart';

class WorkDayModel extends WorkDay {
  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final List<WorkPauseModel> pauseList;

  WorkDayModel({
    @required this.id,
    @required this.employeeId,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
    @required this.pauseList,
  }) : super(
            id: id,
            employeeId: employeeId,
            date: date,
            startTime: startTime,
            endTime: endTime,
            pauseList: pauseList);

  WorkDayModel copyWith({
    String id,
    String employeeId,
    DateTime date,
    DateTime startTime,
    DateTime endTime,
    List<WorkPauseModel> pauseList,
  }) {
    return WorkDayModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pauseList: pauseList ?? this.pauseList,
    );
  }

  factory WorkDayModel.getDefault() {
    return WorkDayModel(
      id: Uuid().v4(),
      employeeId: "employeeId",
      date: DateTime.now(),
      startTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        9,
      ),
      endTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        17,
      ),
      pauseList: [],
    );
  }

  factory WorkDayModel.getDefaultWithDate(DateTime dateTime,
      {@required String employeeId}) {
    return WorkDayModel(
      id: Uuid().v4(),
      employeeId: employeeId,
      date: dateTime,
      startTime: DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        9,
      ),
      endTime: DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        17,
      ),
      pauseList: [],
    );
  }

  factory WorkDayModel.fromJson(Map<String, dynamic> json) {
    List<WorkPauseModel> jsonPauseList = [];
    for (var pause in json["pauseList"] ?? []) {
      jsonPauseList.add(WorkPauseModel.fromJson(pause));
    }
    return WorkDayModel(
      id: json["id"],
      employeeId: json["employeeId"],
      date: DateTime.parse(json["date"]),
      startTime: DateTime.parse(json["startTime"]),
      endTime: DateTime.parse(json["endTime"]),
      pauseList: json["pauseList"] == null ? [] : jsonPauseList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonPauseList = [];
    for (var pause in this.pauseList) {
      jsonPauseList.add(pause.toJson());
    }
    return {
      "id": this.id,
      "employeeId": this.employeeId,
      "date": this.date.toIso8601String(),
      "startTime": this.startTime.toIso8601String(),
      "endTime": this.endTime.toIso8601String(),
      "pauseList": jsonPauseList,
    };
  }
}
