part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class FetchScheduleEvent extends ScheduleEvent {
  final BuildContext context;
  final String businessId;

  FetchScheduleEvent(this.context, {@required this.businessId});
}

class UpdateScheduleEvent extends ScheduleEvent {
  final BuildContext context;

  final String employeeId;
  final List<WorkDay> workDayList;

  UpdateScheduleEvent(this.context,
      {@required this.employeeId, @required this.workDayList});
}

class ResetScheduleEvent extends ScheduleEvent {}

class CrossUpdateScheduleEvent extends ScheduleEvent {
  final List<WorkDay> workDayList;

  CrossUpdateScheduleEvent(this.workDayList);
}

class SelectEmployeeEvent extends ScheduleEvent {
  final Employee employee;

  SelectEmployeeEvent(this.employee);
}
