part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {
  final ScheduleLoaded previousLoaded;

  ScheduleLoading({@required this.previousLoaded});
}

class ScheduleLoaded extends ScheduleState {
  final List<EmployeeModel> employees;
  final Employee selectedEmployee;

  ScheduleLoaded({@required this.employees, @required this.selectedEmployee});
}

class ScheduleError extends ScheduleState {
  final Failure failure;

  ScheduleError(this.failure);
}
