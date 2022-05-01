part of 'city_list_bloc.dart';

abstract class CityListState extends Equatable {
  const CityListState();

  @override
  List<Object> get props => [];
}

class CityListLoaded extends CityListState {
  final List<String> cities;

  CityListLoaded(this.cities);
}

class CityListError extends CityListState {
  final Failure failure;

  CityListError(this.failure);
}

class CityListLoading extends CityListState {}

class CityListInitial extends CityListState {}
