part of 'appointment_list_bloc.dart';

abstract class AppointmentListState extends Equatable {
  const AppointmentListState();

  @override
  List<Object> get props => [];
}

class AppointmentListInitial extends AppointmentListState {}

class AppointmentListLoading extends AppointmentListState {}

class AppointmentListError extends AppointmentListState {
  final Failure failure;

  AppointmentListError(this.failure);
}

class AppointmentListLoaded extends AppointmentListState {
  final PaginationData paginationData;
  final List<Appointment> appointments;

  AppointmentListLoaded(this.paginationData, this.appointments);
}
