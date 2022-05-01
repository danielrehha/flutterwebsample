import 'dart:async';

import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/contracts/i_datasource_location.dart';
import 'package:allbert_cms/data/implementations/datasource_location.dart';
import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'country_list_event.dart';
part 'country_list_state.dart';

class CountryListBloc extends Bloc<CountryListEvent, CountryListState> {
  CountryListBloc() : super(CountryListInitial());

  final ResultFoldHelper foldHelper = ResultFoldHelper();
  final ILocationDataSource dataSource = LocationDataSource();

  @override
  Stream<CountryListState> mapEventToState(
    CountryListEvent event,
  ) async* {
    if (event is FetchCountryListEvent) {
      yield CountryListLoading();
      try {
        final result = await dataSource.loadCountryListAsync();
        final filtered = result
            .where((e) => e.name.toLowerCase().contains("hungary"))
            .toList();
        yield CountryListLoaded(filtered);
      } on ServerException catch (e) {
        yield CountryListError(ServerFailure(e.message));
      } on Exception catch (e) {
        yield CountryListError(AppFailure(e.toString()));
      }
    }
    if (event is ResetCountryListEvent) {
      yield CountryListInitial();
    }
  }
}
