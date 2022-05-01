import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee_settings.dart';
import 'package:allbert_cms/domain/entities/entity_workday.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({@required this.repository}) : super(ScheduleInitial());

  final IBusinessRepository repository;
  final ResultFoldHelper foldHelper = ResultFoldHelper();
  final SnackBarActions snackBarActions = SnackBarActions();

  ScheduleLoaded previousLoadedState;

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    if (event is FetchScheduleEvent) {
      yield ScheduleLoading(previousLoaded: previousLoadedState);
      final result =
          await repository.getScheduleAsync(businessId: event.businessId);
      if (result.isRight()) {
        previousLoadedState = ScheduleLoaded(
          employees: result.getOrElse(() => null),
          selectedEmployee: result.getOrElse(() => null)[0],
        );
        yield previousLoadedState;
      } else {
        final failure = foldHelper.extract(result);
        if (previousLoadedState == null) {
          yield ScheduleError(failure);
        } else {
          snackBarActions.dispatchErrorSnackBar(event.context,
              err: failure.errorMessage);
          yield previousLoadedState;
        }
      }
    }
    if (event is UpdateScheduleEvent) {
      yield ScheduleLoading(previousLoaded: previousLoadedState);
      snackBarActions.dispatchLoadingSnackBar(event.context);
      final result = await repository.updateScheduleAsync(
          employeeId: event.employeeId, workDayList: event.workDayList);
      if (result.isRight()) {
        final oldEmployee = previousLoadedState.employees
            .firstWhere((element) => element.id == event.employeeId);
        int index = previousLoadedState.employees.indexOf(oldEmployee);

        final newEmployee =
            oldEmployee.copyWith(workDayList: result.getOrElse(() => null).workDayList);

        var list = previousLoadedState.employees;
        list[index] = newEmployee;

        ScheduleLoaded newState =
            ScheduleLoaded(employees: list, selectedEmployee: newEmployee);
        previousLoadedState = newState;
        snackBarActions.dispatchSuccessSnackBar(event.context);

        yield previousLoadedState;
      } else {
        final failure = foldHelper.extract(result);
        if (previousLoadedState == null) {
          yield ScheduleError(failure);
        } else {
          snackBarActions.dispatchErrorSnackBar(event.context,
              err: failure.errorMessage);
          yield previousLoadedState;
        }
      }
    }
    if (event is CrossUpdateScheduleEvent) {
      /* final oldEmployee = previousLoadedState.employees
            .firstWhere((element) => element.id == event.employeeId);
        int index = previousLoadedState.employees.indexOf(oldEmployee);

        final newEmployee =
            oldEmployee.copyWith(workDayList: result.getOrElse(() => null));

        var list = previousLoadedState.employees;
        list[index] = newEmployee;

        previousLoadedState = ScheduleLoaded(
            employees: list, selectedEmployee: selectedEmployee ?? list[0]);
        yield previousLoadedState; */
    }
    if (event is SelectEmployeeEvent) {
      yield ScheduleLoading(previousLoaded: previousLoadedState);
      await Future.delayed(Duration(milliseconds: 10));
      ScheduleLoaded newState = ScheduleLoaded(
          employees: previousLoadedState.employees,
          selectedEmployee: event.employee);
      previousLoadedState = newState;
      yield previousLoadedState;
    }
    if (event is ResetScheduleEvent) {
      yield ScheduleInitial();
    }
  }
}
