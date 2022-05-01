import 'package:allbert_cms/data/models/model_customer.dart';
import 'package:meta/meta.dart';

class CustomerListView {
  final int appointmentCount;
  final bool banned;
  final CustomerModel customer;

  CustomerListView({
    @required this.appointmentCount,
    @required this.banned,
    @required this.customer,
  });

  factory CustomerListView.fromJson(Map<String, dynamic> json) {
    return CustomerListView(
      appointmentCount: json["appointmentCount"] ?? 0,
      banned: json["banned"] ?? false,
      customer: CustomerModel.fromJson(json["customer"]),
    );
  }
}
