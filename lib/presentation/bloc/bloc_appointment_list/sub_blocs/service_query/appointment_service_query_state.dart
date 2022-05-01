part of 'appointment_service_query_bloc.dart';

abstract class AppointmentServiceQueryState extends Equatable {
  const AppointmentServiceQueryState();

  @override
  List<Object> get props => [];
}

class AppointmentServiceQueryInitial extends AppointmentServiceQueryState {}

class AppointmentServiceQueryLoading extends AppointmentServiceQueryState {}

class AppointmentServiceQueryLoaded extends AppointmentServiceQueryState {
  final List<Service> services;

  AppointmentServiceQueryLoaded(this.services);
}

class AppointmentServiceQueryError extends AppointmentServiceQueryState {
  final Failure failure;

  AppointmentServiceQueryError(this.failure);
}
