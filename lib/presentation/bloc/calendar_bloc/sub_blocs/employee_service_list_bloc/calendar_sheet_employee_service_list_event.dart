part of 'calendar_sheet_employee_service_list_bloc.dart';

abstract class CalendarSheetEmployeeServiceListEvent extends Equatable {
  const CalendarSheetEmployeeServiceListEvent();

  @override
  List<Object> get props => [];
}

class FetchCalendarSheetEmployeeServiceListEvent
    extends CalendarSheetEmployeeServiceListEvent {
  final String employeeId;

  FetchCalendarSheetEmployeeServiceListEvent(this.employeeId);
}

class ResetCalendarSheetEmployeeServiceListEvent extends CalendarSheetEmployeeServiceListEvent {}
