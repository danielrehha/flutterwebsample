part of 'appointment_service_query_bloc.dart';

abstract class AppointmentServiceQueryEvent extends Equatable {
  const AppointmentServiceQueryEvent();

  @override
  List<Object> get props => [];
}

class FetchAppointmentServiceQueryEvent extends AppointmentServiceQueryEvent {
  final String businessId;

  FetchAppointmentServiceQueryEvent(this.businessId);
}

class ResetAppointmentServiceQueryEvent extends AppointmentServiceQueryEvent {}
