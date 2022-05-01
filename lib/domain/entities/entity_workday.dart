import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'entity_workpause.dart';

class WorkDay extends Equatable {
  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final List<WorkPause> pauseList;

  WorkDay({
    @required this.id,
    @required this.employeeId,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
    @required this.pauseList,
  });

  @override
  List<Object> get props => [
        id,
        employeeId,
        date,
        startTime,
        endTime,
        pauseList,
      ];
}
