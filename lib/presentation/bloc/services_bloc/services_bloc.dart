import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/domain/repositories/repository_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc({@required this.repository}) : super(ServicesInitial());

  final IServiceRepository repository;
  ServicesLoadedState previousLoadedState;

  @override
  Stream<ServicesState> mapEventToState(
    ServicesEvent event,
  ) async* {
    yield ServicesAwaitingState();
    if (event is FetchServicesEvent) {
      final result =
          await repository.getServiceListAsync(businessId: event.businessId);
      if (result is Right) {
        previousLoadedState =
            ServicesLoadedState(services: result.getOrElse(() => null));
        yield previousLoadedState;
      } else {
        Failure failure;
        result.fold((l) => failure = l, (r) => null);
        yield ServicesErrorState(failure: failure);
      }
    }
    if (event is AddServiceEvent) {
      final result = await repository.createServiceAsync(
          service: event.service);
      if (result is Right) {
        previousLoadedState.services.add(event.service);
        yield previousLoadedState;
      } else {
        Failure failure;
        result.fold((l) => failure = l, (r) => null);
        yield ServicesErrorState(failure: failure);
      }
    }
    if (event is EditServiceEvent) {
      final result = await repository.updateServiceAsync(
          service: event.service);
      if (result.isRight()) {
        final service = event.service;
        final oldService = previousLoadedState.services
            .firstWhere((e) => e.id == service.id);
        int serviceIndex = previousLoadedState.services.indexOf(oldService);
        previousLoadedState.services[serviceIndex] = service;
        yield previousLoadedState;
      } else {
        Failure failure;
        result.fold((l) => failure = l, (r) => null);
        yield ServicesErrorState(failure: failure);
      }
    }
    if (event is DeleteServiceEvent) {
      final result = await repository.deleteServiceAsync(serviceId: event.serviceId);
      if (result is Right) {
        previousLoadedState.services
            .removeWhere((e) => e.id == event.serviceId);
        yield previousLoadedState;
      } else {
        Failure failure;
        result.fold((l) => failure = l, (r) => null);
        yield ServicesErrorState(failure: failure);
      }
    }
    if (event is ResetServicesEvent) {
      yield ServicesInitial();
    }
  }
}
