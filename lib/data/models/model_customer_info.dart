import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_customer_info.dart';
import 'package:meta/meta.dart';

class CustomerInfoModel extends CustomerInfo
    implements ISerializable<CustomerInfoModel> {
  final String customerId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String phoneIso;

  CustomerInfoModel({
    @required this.customerId,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phone,
    @required this.phoneIso,
  }) : super(
          customerId: customerId,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          phoneIso: phoneIso,
        );

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return CustomerInfoModel(
      customerId: json['customerId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      phoneIso: json["phoneIso"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': this.customerId,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.lastName,
      'phone': this.phone,
      "phoneIso": this.phoneIso,
    };
  }

  CustomerInfoModel copyWith({
    String customerId,
    String firstName,
    String lastName,
    String email,
    String phone,
    String phoneIso,
  }) {
    return CustomerInfoModel(
      customerId: customerId ?? this.customerId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneIso: phoneIso ?? this.phoneIso,
    );
  }

  @override
  CustomerInfoModel fromJson(Map<String, dynamic> json) {
    return CustomerInfoModel.fromJson(json);
  }
}
