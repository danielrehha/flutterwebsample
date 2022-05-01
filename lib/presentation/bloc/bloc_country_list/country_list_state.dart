part of 'country_list_bloc.dart';

abstract class CountryListState extends Equatable {
  const CountryListState();

  @override
  List<Object> get props => [];
}

class CountryListInitial extends CountryListState {}

class CountryListLoaded extends CountryListState {
  final List<Country> countries;

  CountryListLoaded(this.countries);
}

class CountryListError extends CountryListState {
  final Failure failure;

  CountryListError(this.failure);
}

class CountryListLoading extends CountryListState {}
