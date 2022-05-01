part of 'calendar_sheet_employee_service_list_bloc.dart';

abstract class CalendarSheetEmployeeServiceListState extends Equatable {
  const CalendarSheetEmployeeServiceListState();

  @override
  List<Object> get props => [];
}

class CalendarSheetEmployeeServiceListInitial
    extends CalendarSheetEmployeeServiceListState {}

class CalendarSheetEmployeeServiceListLoaded
    extends CalendarSheetEmployeeServiceListState {
  final List<Service> services;

  CalendarSheetEmployeeServiceListLoaded(this.services);
}

class CalendarSheetEmployeeServiceListLoading
    extends CalendarSheetEmployeeServiceListState {}

class CalendarSheetEmployeeServiceListError
    extends CalendarSheetEmployeeServiceListState {
  final Failure failure;

  CalendarSheetEmployeeServiceListError(this.failure);
}
