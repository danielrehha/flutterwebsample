part of 'appointment_employee_query_bloc.dart';

abstract class AppointmentEmployeeQueryState extends Equatable {
  const AppointmentEmployeeQueryState();

  @override
  List<Object> get props => [];
}

class AppointmentEmployeeQueryInitial extends AppointmentEmployeeQueryState {}

class AppointmentEmployeeQueryLoading extends AppointmentEmployeeQueryState {}

class AppointmentEmployeeQueryLoaded extends AppointmentEmployeeQueryState {
  final List<Employee> employees;

  AppointmentEmployeeQueryLoaded(this.employees);
}

class AppointmentEmployeeQueryError extends AppointmentEmployeeQueryState {
  final Failure failure;

  AppointmentEmployeeQueryError(this.failure);
}
