part of 'appointment_list_bloc.dart';

abstract class AppointmentListEvent extends Equatable {
  const AppointmentListEvent();

  @override
  List<Object> get props => [];
}

class FetchAppointmentListEvent extends AppointmentListEvent {
  final String businessId;
  final AppointmentQueryParameters parameters;
  final String url;

  FetchAppointmentListEvent(this.businessId, {this.parameters, this.url});
}

class ResetAppointmentListEvent extends AppointmentListEvent {}
