import 'package:allbert_cms/data/models/model_employee_service.dart';
import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_employee_info.dart';
import 'package:meta/meta.dart';

class EmployeeInfoModel extends EmployeeInfo
    implements ISerializable<EmployeeInfoModel> {
  final List<EmployeeServiceModel> services;
  EmployeeInfoModel({
    String employeeId,
    String firstName,
    String lastName,
    String job,
    String description,
    String email,
    String phone,
    String phoneIso,
    int color,
    @required this.services,
  }) : super(
          employeeId: employeeId,
          firstName: firstName,
          lastName: lastName,
          job: job,
          description: description,
          email: email,
          phone: phone,
          phoneIso: phoneIso,
          color: color,
          services: services,
        );

  factory EmployeeInfoModel.fromJson(Map<String, dynamic> json) {
    List<EmployeeServiceModel> newServices = [];
    if (json['services'] != null) {
      for (var service in json['services']) {
        newServices.add(EmployeeServiceModel.fromJson(service));
      }
    }

    return EmployeeInfoModel(
      employeeId: json['employeeId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      job: json['job'],
      description: json['description'],
      email: json['email'],
      phone: json['phone'],
      phoneIso: json['phoneIso'],
      color: json['color'],
      services: newServices,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': '${this.employeeId}',
      'firstName': '${this.firstName}',
      'lastName': '${this.lastName}',
      'job': '${this.job}',
      'description': '${this.description}',
      'email': '${this.email}',
      'phone': '${this.phone}',
      'phoneIso': '${this.phoneIso}',
      'color': '${this.color}',
      'services': servicesToJson(),
    };
  }

  List<Map<String, dynamic>> servicesToJson() {
    List<Map<String, dynamic>> serializedServices = [];
    if (services != null && services.isNotEmpty) {
      for (var service in services) {
        serializedServices.add(service.toJson());
      }
    }
    return serializedServices;
  }

  EmployeeInfoModel copyWith({
    String employeeId,
    String firstName,
    String lastName,
    String job,
    String description,
    String email,
    String phone,
    String phoneIso,
    int color,
    List<EmployeeServiceModel> services,
  }) {
    return EmployeeInfoModel(
      employeeId: employeeId ?? this.employeeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      job: job ?? this.job,
      description: description ?? this.description,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneIso: phoneIso ?? this.phoneIso,
      color: color ?? this.color,
      services: services ?? this.services,
    );
  }

  @override
  EmployeeInfoModel fromJson(Map<String, dynamic> json) {
    return EmployeeInfoModel.fromJson(json);
  }
}
