import 'package:allbert_cms/domain/entities/entity_workpause.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class WorkPauseModel extends WorkPause {
  final String id;
  final String workdayId;
  final int index;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  WorkPauseModel({
    @required this.id,
    @required this.workdayId,
    @required this.index,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
  });

  WorkPauseModel copyWith({
    String id,
    String workdayId,
    int index,
    DateTime date,
    DateTime startTime,
    DateTime endTime,
  }) {
    return WorkPauseModel(
      id: id ?? this.id,
      workdayId: workdayId ?? this.workdayId,
      index: index ?? this.index,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  factory WorkPauseModel.getDefault(int index, {@required String workdayId}) {
    return WorkPauseModel(
      id: Uuid().v4(),
      workdayId: workdayId,
      index: index,
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      startTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        12,
      ),
      endTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        13,
      ),
    );
  }

  factory WorkPauseModel.fromJson(Map<String, dynamic> json) {
    return WorkPauseModel(
      id: json["id"],
      workdayId: json["workdayId"],
      index: json["index"] ?? 0,
      date: DateTime.parse(json["date"] ?? DateTime.now().toIso8601String()),
      startTime: DateTime.parse(json["startTime"]),
      endTime: DateTime.parse(json["endTime"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "workdayId": this.workdayId,
      "index": this.index,
      "date": this.date.toIso8601String(),
      "startTime": this.startTime.toIso8601String(),
      "endTime": this.endTime.toIso8601String(),
    };
  }
}
