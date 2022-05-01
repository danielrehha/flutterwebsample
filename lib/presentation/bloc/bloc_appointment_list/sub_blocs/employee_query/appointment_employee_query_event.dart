part of 'appointment_employee_query_bloc.dart';

abstract class AppointmentEmployeeQueryEvent extends Equatable {
  const AppointmentEmployeeQueryEvent();

  @override
  List<Object> get props => [];
}

class FetchAppointmentEmployeeQueryEvent extends AppointmentEmployeeQueryEvent {
  final String businessId;

  FetchAppointmentEmployeeQueryEvent(this.businessId);
}

class ResetAppointmentEmployeeQueryEvent extends AppointmentEmployeeQueryEvent {}
