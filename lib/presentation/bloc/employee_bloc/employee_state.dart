part of 'employee_bloc.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object> get props => [];
}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoadedState extends EmployeesState {
  final List<EmployeeModel> employees;

  EmployeesLoadedState({@required this.employees});
}

class EmployeeAddOrEditAwaitingState extends EmployeesState {
  EmployeeAddOrEditAwaitingState();
}

class EmployeesLoadingState extends EmployeesState {
  EmployeesLoadingState();
}

class EmployeeAddOrEditErrorState extends EmployeesState {
  final Failure failure;

  EmployeeAddOrEditErrorState({@required this.failure});
}

class EmployeesErrorState extends EmployeesState {
  final Failure failure;

  EmployeesErrorState({@required this.failure});
}
