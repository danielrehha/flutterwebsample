import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/data/models/model_employee_info.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_employee_info.dart';
import 'package:allbert_cms/domain/repositories/repository_employee.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeesState> {
  EmployeeBloc({@required this.repository}) : super(EmployeesInitial());

  final IEmployeeRepository repository;
  EmployeesLoadedState previousLoadedState;

  @override
  Stream<EmployeesState> mapEventToState(
    EmployeeEvent event,
  ) async* {
    if (event is FetchEmployeesEvent) {
      yield EmployeesLoadingState();
      final result =
          await repository.getEmployeeListAsync(businessId: event.businessId);
      if (result.isRight()) {
        previousLoadedState =
            EmployeesLoadedState(employees: result.getOrElse(() => null));
        yield previousLoadedState;
      } else {
        String message;
        result.fold((l) => message = l.errorMessage, (r) => null);
        yield EmployeesErrorState(failure: ServerFailure(message));
      }
    }
    if (event is EditEmployeeEvent) {
      yield EmployeeAddOrEditAwaitingState();
      final result = await repository.updateEmployeeAsync(
          employeeInfo: event.employeeInfo);
      if (result.isRight()) {
        final employee = previousLoadedState.employees.firstWhere(
            (element) => element.id == event.employeeInfo.employeeId);
        int employeeIndex = previousLoadedState.employees.indexOf(employee);
        final updatedEmployee = employee.copyWith(info: event.employeeInfo);
        previousLoadedState.employees[employeeIndex] = updatedEmployee;
        yield previousLoadedState;
      } else {
        String message;
        result.fold((l) => message = l.errorMessage, (r) => null);
        yield EmployeeAddOrEditErrorState(failure: ServerFailure(message));
      }
    }
    if (event is AddEmployeeEvent) {
      yield EmployeeAddOrEditAwaitingState();
      final result = await repository.createEmployeeAsync(
          businessId: event.businessId, employeeInfo: event.employeeInfo);
      if (result.isRight()) {
        previousLoadedState.employees.add(result.getOrElse(() {
          return null;
        }));
        yield previousLoadedState;
      } else {
        String message;
        result.fold((l) => message = l.errorMessage, (r) => null);
        yield EmployeesErrorState(failure: ServerFailure(message));
      }
    }
    if (event is DeleteEmployeeEvent) {
      yield EmployeesLoadingState();
      final result =
          await repository.deleteEmployeeAsync(employeeId: event.employeeId);
      if (result.isRight()) {
        previousLoadedState.employees
            .removeWhere((e) => e.id == event.employeeId);
        yield previousLoadedState;
      } else {
        String message;
        result.fold((l) => message = l.errorMessage, (r) => null);
        yield EmployeesErrorState(failure: ServerFailure(message));
      }
    }
    if (event is CrossUpdateAvatarEvent) {
      yield EmployeeAddOrEditAwaitingState();
      final oldEmployee = previousLoadedState.employees
          .firstWhere((element) => element.id == event.employeeId);
      final updatedEmployee = oldEmployee.copyWith(avatar: event.image);
      int indexOf = previousLoadedState.employees.indexOf(oldEmployee);
      previousLoadedState.employees[indexOf] = updatedEmployee;
      yield previousLoadedState;
    }
    if (event is ResetEmployeeEvent) {
      yield EmployeesInitial();
    }
    if (event is CrossUpdateEmployeesEvent) {
      yield EmployeesLoadingState();

      previousLoadedState = EmployeesLoadedState(employees: event.employees);
      yield previousLoadedState;
    }
  }
}
