import 'package:allbert_cms/data/models/model_customer.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_customer.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:meta/meta.dart';

class AppointmentModel extends Appointment {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int status;
  final String employeeId;
  final EmployeeModel employee;
  final String businessId;
  final String customerId;
  final CustomerModel customer;
  final String serviceId;
  final ServiceModel service;

  AppointmentModel({
    @required this.id,
    @required this.startDate,
    @required this.endDate,
    @required this.status,
    @required this.employeeId,
    @required this.employee,
    this.businessId,
    @required this.customerId,
    @required this.customer,
    @required this.serviceId,
    @required this.service,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
          status: status,
          employeeId: employeeId,
          employee: employee,
          businessId: businessId,
          customerId: customerId,
          customer: customer,
          serviceId: serviceId,
          service: service,
        );

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      startDate: DateTime.parse(
        json['startDate'],
      ),
      endDate: DateTime.parse(
        json['endDate'],
      ),
      status: json['status'],
      employeeId: json['employeeId'],
      employee: json["employee"] == null
          ? null
          : EmployeeModel.fromJson(json["employee"]),
      businessId: json["businessId"],
      customerId: json['customerId'],
      customer: json["customer"] == null
          ? null
          : CustomerModel.fromJson(json['customer']),
      serviceId: json['serviceId'],
      service: json["service"] == null
          ? null
          : ServiceModel.fromJson(json['service']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'startDate': this.startDate.toIso8601String(),
      'endDate': this.endDate.toIso8601String(),
      'status': this.status ?? 0,
      'employeeId': this.employeeId,
      'businessId': this.businessId,
      'customerId': this.customerId,
      'serviceId': this.serviceId,
    };
  }

  AppointmentModel copyWith({
    String id,
    DateTime startDate,
    DateTime endDate,
    int status,
    String employeeId,
    Employee employee,
    String businessId,
    String customerId,
    Customer customer,
    String serviceId,
    Service service,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      employeeId: employeeId ?? this.employeeId,
      employee: employee ?? this.employee,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      customer: customer ?? this.customer,
      serviceId: serviceId ?? this.serviceId,
      service: service ?? this.service,
    );
  }
}
