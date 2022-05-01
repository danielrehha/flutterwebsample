part of 'customer_list_bloc.dart';

abstract class CustomerListEvent extends Equatable {
  const CustomerListEvent();

  @override
  List<Object> get props => [];
}

class FetchCustomerListEvent extends CustomerListEvent {
  final String businessId;
  final CustomerQueryParameters parameters;
  final String url;

  FetchCustomerListEvent(this.businessId, {this.parameters, this.url});
}

class ResetCustomerListEvent extends CustomerListEvent {}
