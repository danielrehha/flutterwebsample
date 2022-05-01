import 'package:allbert_cms/domain/entities/entity_business_contact.dart';
import 'package:meta/meta.dart';

class BusinessContactModel extends BusinessContact {
  final String businessId;
  final String firstName;
  final String lastName;
  final String phone;
  final String phoneIso;
  final String email;

  BusinessContactModel({
    @required this.businessId,
    @required this.firstName,
    @required this.lastName,
    @required this.phone,
    @required this.phoneIso,
    @required this.email,
  }) : super(
          businessId: businessId,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          phoneIso: phoneIso,
          email: email,
        );

  factory BusinessContactModel.fromJson(Map<String, dynamic> json) {
    return BusinessContactModel(
      businessId: json["businessId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      phone: json["phone"],
      phoneIso: json["phoneIso"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "businessId": this.businessId,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "phone": this.phone,
      "phoneIso": this.phoneIso,
      "email": this.email,
    };
  }
}
