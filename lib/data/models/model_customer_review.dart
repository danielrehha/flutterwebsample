import 'package:allbert_cms/data/models/model_customer.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_customer.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_customer_review.dart';
import 'package:meta/meta.dart';

class CustomerReviewModel extends CustomerReview implements ISerializable<CustomerReviewModel> {
  final String id;
  final int rating;
  final String comment;
  final String customerId;
  final CustomerModel customer;
  final String employeeId;
  final DateTime createdOn;

  CustomerReviewModel({
    @required this.id,
    @required this.rating,
    @required this.comment,
    @required this.customerId,
    @required this.customer,
    @required this.employeeId,
    @required this.createdOn,
  }) : super(
          id: id,
          rating: rating,
          comment: comment,
          customerId: customerId,
          customer: customer,
          employeeId: employeeId,
          createdOn: createdOn,
        );

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) {
    return CustomerReviewModel(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'] ?? null,
      customerId: json['customerId'],
      customer: CustomerModel.fromJson(json['customer']),
      employeeId: json['employeeId'],
      createdOn: DateTime.parse(json["createdOn"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'score': this.rating,
      'comment': this.comment,
      'customerId': this.customerId,
      'customer': this.customer.toJson(),
      'employeeId': this.employeeId,
    };
  }

  CustomerReviewModel copyWith({
    String id,
    int score,
    String comment,
    String customerId,
    Customer customer,
    String employeeId,
    Employee employee,
    DateTime createdOn,
  }) {
    return CustomerReviewModel(
      id: id ?? this.id,
      rating: score ?? this.rating,
      comment: comment ?? this.comment,
      customerId: customerId ?? this.customerId,
      customer: customer ?? this.customer,
      employeeId: employeeId ?? this.employeeId,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  @override
  CustomerReviewModel fromJson(Map<String, dynamic> json) {
    return CustomerReviewModel.fromJson(json);
  }
}
