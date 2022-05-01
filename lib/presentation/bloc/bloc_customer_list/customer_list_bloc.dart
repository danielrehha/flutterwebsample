import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_list_view.dart';
import 'package:allbert_cms/domain/helpers/customer_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/pagination_data.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_list_event.dart';
part 'customer_list_state.dart';

class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState> {
  CustomerListBloc({this.repository}) : super(CustomerListInitial());

  final ResultFoldHelper foldHelper = ResultFoldHelper();
  final IBusinessRepository repository;

  @override
  Stream<CustomerListState> mapEventToState(
    CustomerListEvent event,
  ) async* {
    if (event is FetchCustomerListEvent) {
      yield CustomerListLoading();
      final result = await repository.getBusinessCustomerListAsync(
          businessId: event.businessId,
          parameters: event.parameters,
          url: event.url);
      if (result.isRight()) {
        yield CustomerListLoaded(result.getOrElse(() => null).paginationData,
            result.getOrElse(() => null).items);
      } else {
        yield CustomerListError(foldHelper.extract(result));
      }
    }
    if (event is ResetCustomerListEvent) {
      yield CustomerListInitial();
    }
  }
}
