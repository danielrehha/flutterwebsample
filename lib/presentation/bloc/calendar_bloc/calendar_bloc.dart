import 'dart:async';
import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/domain/repositories/repository_employee.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({@required this.repository, @required this.businessRepository})
      : super(CalendarInitial());

  final IEmployeeRepository repository;
  final IBusinessRepository businessRepository;
  CalendarLoadedState previousLoadedState;

  @override
  Stream<CalendarState> mapEventToState(
    CalendarEvent event,
  ) async* {
    yield CalendarLoadingState();
    if (event is FetchCalendarEvent) {
      final result = await businessRepository.getEmployeeScheduleListAsync(
          businessId: event.businessId, from: event.from, until: event.until);
      if (result.isRight()) {
        previousLoadedState = CalendarLoadedState(
          employees: result.getOrElse(() => null),
          selectedEmployee: result.getOrElse(() => null).isEmpty
              ? null
              : result.getOrElse(() => null)[0],
        );
        yield previousLoadedState;
      } else {
        Failure failure;
        result.fold((l) => failure = l, (r) => null);
        yield CalendarErrorState(failure: failure);
      }
    }
    if (event is ResetCalendarEvent) {
      yield CalendarInitial();
    }
    if (event is SelectEmployeeEvent) {
      CalendarLoadedState newState = CalendarLoadedState(
          employees: previousLoadedState.employees,
          selectedEmployee: event.employee);
      previousLoadedState = newState;
      yield newState;
    }
  }
}
