part of 'customer_list_bloc.dart';

abstract class CustomerListState extends Equatable {
  const CustomerListState();

  @override
  List<Object> get props => [];
}

class CustomerListInitial extends CustomerListState {}

class CustomerListLoading extends CustomerListState {}

class CustomerListError extends CustomerListState {
  final Failure failure;

  CustomerListError(this.failure);
}

class CustomerListLoaded extends CustomerListState {
  final PaginationData paginationData;
  final List<CustomerListView> appointments;

  CustomerListLoaded(this.paginationData, this.appointments);
}
