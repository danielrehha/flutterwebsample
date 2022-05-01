import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/domain/repositories/repository_employee.dart';
import 'package:allbert_cms/domain/repositories/repository_service.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'calendar_sheet_employee_service_list_event.dart';
part 'calendar_sheet_employee_service_list_state.dart';

class CalendarSheetEmployeeServiceListBloc extends Bloc<
    CalendarSheetEmployeeServiceListEvent,
    CalendarSheetEmployeeServiceListState> {
  CalendarSheetEmployeeServiceListBloc({@required this.dataSource})
      : super(CalendarSheetEmployeeServiceListInitial());

  final IEmployeeRepository dataSource;
  final ResultFoldHelper foldHelper = ResultFoldHelper();

  @override
  Stream<CalendarSheetEmployeeServiceListState> mapEventToState(
      CalendarSheetEmployeeServiceListEvent event) async* {
    if (event is FetchCalendarSheetEmployeeServiceListEvent) {
      yield CalendarSheetEmployeeServiceListLoading();
      final result = await dataSource.getEmployeeServiceListAsync(
          employeeId: event.employeeId);
      if (result.isRight()) {
        yield CalendarSheetEmployeeServiceListLoaded(result.getOrElse(() => <Service>[]));
      } else {
        yield CalendarSheetEmployeeServiceListError(foldHelper.extract(result));
      }
    }
  }
}
