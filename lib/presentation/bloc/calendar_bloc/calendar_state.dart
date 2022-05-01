part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoadingState extends CalendarState {}

class CalendarLoadedState extends CalendarState {
  final List<EmployeeModel> employees;
  final EmployeeModel selectedEmployee;

  CalendarLoadedState(
      {@required this.employees, @required this.selectedEmployee});
}

class CalendarErrorState extends CalendarState {
  final Failure failure;

  CalendarErrorState({@required this.failure});
}
