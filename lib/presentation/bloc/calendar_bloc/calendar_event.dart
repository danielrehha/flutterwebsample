part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class FetchCalendarEvent extends CalendarEvent {
  final String businessId;
  final DateTime from;
  final DateTime until;

  FetchCalendarEvent({@required this.businessId, @required this.from, @required this.until});
}

class ResetCalendarEvent extends CalendarEvent {}

class SelectEmployeeEvent extends CalendarEvent {
  final Employee employee;

  SelectEmployeeEvent({@required this.employee});
}
