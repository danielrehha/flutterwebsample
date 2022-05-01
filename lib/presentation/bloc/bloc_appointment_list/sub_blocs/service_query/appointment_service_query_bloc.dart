import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/domain/repositories/repository_service.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointment_service_query_event.dart';
part 'appointment_service_query_state.dart';

class AppointmentServiceQueryBloc
    extends Bloc<AppointmentServiceQueryEvent, AppointmentServiceQueryState> {
  AppointmentServiceQueryBloc({this.repository})
      : super(AppointmentServiceQueryInitial());

  final IServiceRepository repository;
  final ResultFoldHelper foldHelper = ResultFoldHelper();

  @override
  Stream<AppointmentServiceQueryState> mapEventToState(
    AppointmentServiceQueryEvent event,
  ) async* {
    if (event is FetchAppointmentServiceQueryEvent) {
      yield AppointmentServiceQueryLoading();
      final result =
          await repository.getServiceListAsync(businessId: event.businessId);
      if (result.isRight()) {
        yield AppointmentServiceQueryLoaded(result.getOrElse(() => null));
      } else {
        yield AppointmentServiceQueryError(foldHelper.extract(result));
      }
    }
    if (event is ResetAppointmentServiceQueryEvent) {
      yield AppointmentServiceQueryInitial();
    }
  }
}
