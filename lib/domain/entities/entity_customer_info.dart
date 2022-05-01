import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CustomerInfo extends Equatable {
  final String customerId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String phoneIso;

  CustomerInfo({
    @required this.customerId,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phone,
    @required this.phoneIso,
  });

  @override
  List<Object> get props => [
        customerId,
        firstName,
        lastName,
        email,
        phone,
        phoneIso,
      ];
}
