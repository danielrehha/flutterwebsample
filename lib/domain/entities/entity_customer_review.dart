import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'entity_customer.dart';
import 'entity_employee.dart';

class CustomerReview extends Equatable {
  final String id;
  final int rating;
  final String comment;
  final String customerId;
  final Customer customer;
  final String employeeId;
  final DateTime createdOn;

  CustomerReview({
    @required this.id,
    @required this.rating,
    @required this.comment,
    @required this.customerId,
    @required this.customer,
    @required this.employeeId,
    @required this.createdOn,
  });

  @override
  List<Object> get props => [
        id,
        rating,
        comment,
        customerId,
        customer,
        employeeId,
        createdOn,
      ];
}
