import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class WorkPause extends Equatable {
  final String id;
  final String workdayId;
  final int index;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  WorkPause({
    @required this.id,
    @required this.workdayId,
    @required this.index,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
  });

  @override
  List<Object> get props => [
        id,
        workdayId,
        index,
        date,
        startTime,
        endTime,
      ];

  int get durationInMinutes => endTime.difference(startTime).inMinutes;
}
