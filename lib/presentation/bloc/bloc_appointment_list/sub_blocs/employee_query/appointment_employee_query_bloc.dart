import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/repositories/repository_employee.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointment_employee_query_event.dart';
part 'appointment_employee_query_state.dart';

class AppointmentEmployeeQueryBloc
    extends Bloc<AppointmentEmployeeQueryEvent, AppointmentEmployeeQueryState> {
  AppointmentEmployeeQueryBloc({this.repository})
      : super(AppointmentEmployeeQueryInitial());

  final IEmployeeRepository repository;
  final ResultFoldHelper foldHelper = ResultFoldHelper();

  @override
  Stream<AppointmentEmployeeQueryState> mapEventToState(
    AppointmentEmployeeQueryEvent event,
  ) async* {
    if (event is FetchAppointmentEmployeeQueryEvent) {
      yield AppointmentEmployeeQueryLoading();
      final result =
          await repository.getEmployeeListAsync(businessId: event.businessId);
      if (result.isRight()) {
        yield AppointmentEmployeeQueryLoaded(result.getOrElse(() => null));
      } else {
        yield AppointmentEmployeeQueryError(foldHelper.extract(result));
      }
    }
    if (event is ResetAppointmentEmployeeQueryEvent) {
      yield AppointmentEmployeeQueryInitial();
    }
  }
}
