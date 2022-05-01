import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/contracts/i_datasource_location.dart';
import 'package:allbert_cms/data/implementations/datasource_location.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'city_list_event.dart';
part 'city_list_state.dart';

class CityListBloc extends Bloc<CityListEvent, CityListState> {
  CityListBloc() : super(CityListInitial());

  final ILocationDataSource locationDataSource = LocationDataSource();

  @override
  Stream<CityListState> mapEventToState(CityListEvent event) async* {
    if (event is FetchCityListEvent) {
      yield CityListLoading();
      try {
        final result = await locationDataSource.loadCityListAsync(
          countryCode: event.countryCode,
            queryString: event.queryString);
        yield CityListLoaded(result);
      } on ServerException catch (e) {
        yield CityListError(ServerFailure(e.message));
      } on Exception catch (e) {
        yield CityListError(AppFailure(e.toString()));
      }
    }
    if (event is ResetCityListEvent) {
      yield CityListInitial();
    }
  }
}
