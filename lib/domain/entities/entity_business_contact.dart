import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BusinessContact extends Equatable {
  final String businessId;
  final String firstName;
  final String lastName;
  final String phone;
  final String phoneIso;
  final String email;

  BusinessContact({
    @required this.businessId,
    @required this.firstName,
    @required this.lastName,
    @required this.phone,
    @required this.phoneIso,
    @required this.email,
  });

  @override
  List<Object> get props => [
        businessId,
        firstName,
        lastName,
        phone,
        phoneIso,
        email,
      ];
}
