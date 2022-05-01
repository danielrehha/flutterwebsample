import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class EmployeeWorkBlock implements Equatable {
  final String id;
  final String employeeId;
  final DateTime startTime;
  final DateTime endTime;
  final String description;

  EmployeeWorkBlock({
    @required this.id,
    @required this.employeeId,
    @required this.startTime,
    @required this.endTime,
    @required this.description,
  });

  @override
  List<Object> get props => [
        id,
        employeeId,
        startTime,
        endTime,
        description,
      ];

  @override
  bool get stringify => false;

  Duration get duration => endTime.difference(startTime);
}
