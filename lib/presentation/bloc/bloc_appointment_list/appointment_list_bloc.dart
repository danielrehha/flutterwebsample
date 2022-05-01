import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/helpers/appointment_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/pagination_data.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointment_list_event.dart';
part 'appointment_list_state.dart';

class AppointmentListBloc
    extends Bloc<AppointmentListEvent, AppointmentListState> {
  AppointmentListBloc({this.repository}) : super(AppointmentListInitial());

  final ResultFoldHelper foldHelper = ResultFoldHelper();
  final IBusinessRepository repository;

  @override
  Stream<AppointmentListState> mapEventToState(
    AppointmentListEvent event,
  ) async* {
    if (event is FetchAppointmentListEvent) {
      yield AppointmentListLoading();
      final result = await repository.getBusinessAppointmentListAsyncV2(
          businessId: event.businessId,
          parameters: event.parameters,
          url: event.url);
      if (result.isRight()) {
        yield AppointmentListLoaded(result.getOrElse(() => null).paginationData,
            result.getOrElse(() => null).items);
      } else {
        yield AppointmentListError(foldHelper.extract(result));
      }
    }
    if(event is ResetAppointmentListEvent) {
      yield AppointmentListInitial();
    }
  }
}
