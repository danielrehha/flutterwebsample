import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_employee_service.dart';
import 'package:meta/meta.dart';

class EmployeeServiceModel extends EmployeeService
    implements ISerializable<EmployeeServiceModel> {
  final String employeeId;
  final String serviceId;
  final ServiceModel service;

  EmployeeServiceModel({
    @required this.employeeId,
    @required this.serviceId,
    @required this.service,
  }) : super(
          employeeId: employeeId,
          serviceId: serviceId,
          service: service,
        );

  factory EmployeeServiceModel.fromJson(Map<String, dynamic> json) {
    return EmployeeServiceModel(
        employeeId: json['employeeId'],
        serviceId: json['serviceId'],
        service: json["service"] == null
            ? null
            : ServiceModel.fromJson(json["service"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': '${this.employeeId}',
      'serviceId': '${this.serviceId}',
      //"service": this.service.toJson(),
    };
  }

  EmployeeServiceModel copyWith({
    String employeeId,
    String serviceId,
    ServiceModel service,
  }) {
    return EmployeeServiceModel(
      employeeId: employeeId ?? this.employeeId,
      serviceId: serviceId ?? this.serviceId,
      service: service ?? this.service,
    );
  }

  @override
  EmployeeServiceModel fromJson(Map<String, dynamic> json) {
    return EmployeeServiceModel.fromJson(json);
  }
}
