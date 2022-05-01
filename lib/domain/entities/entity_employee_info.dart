import 'package:allbert_cms/domain/entities/entity_employee_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class EmployeeInfo extends Equatable {
  final String employeeId;
  final String firstName;
  final String lastName;
  final String job;
  final String description;
  final String email;
  final String phone;
  final String phoneIso;
  final int color;
  final List<EmployeeService> services;

  EmployeeInfo({
    @required this.employeeId,
    @required this.firstName,
    @required this.lastName,
    @required this.job,
    @required this.description,
    @required this.email,
    @required this.phone,
    @required this.phoneIso,
    @required this.color,
    @required this.services,
  });

  @override
  List<Object> get props => [
        employeeId,
        firstName,
        lastName,
        job,
        description,
        email,
        phone,
        phoneIso,
        color,
        services,
      ];
}
