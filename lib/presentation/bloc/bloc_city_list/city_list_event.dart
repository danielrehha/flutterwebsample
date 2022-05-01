part of 'city_list_bloc.dart';

abstract class CityListEvent extends Equatable {
  const CityListEvent();

  @override
  List<Object> get props => [];
}

class FetchCityListEvent extends CityListEvent {
  final String countryCode;
  final String queryString;

  FetchCityListEvent({@required this.countryCode, this.queryString = ""});
}

class ResetCityListEvent extends CityListEvent {}
