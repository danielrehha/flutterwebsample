import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'entity_service.dart';
import 'entity_customer.dart';

class Appointment extends Equatable {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int status;
  final String employeeId;
  final Employee employee;
  final String businessId;
  final String customerId;
  final Customer customer;
  final String serviceId;
  final Service service;

  Appointment({
    @required this.id,
    @required this.startDate,
    @required this.endDate,
    @required this.status,
    @required this.employeeId,
    this.employee,
    this.businessId,
    @required this.customerId,
    this.customer,
    @required this.serviceId,
    this.service,
  });

  @override
  List<Object> get props => [
        id,
        startDate,
        endDate,
        status,
        employeeId,
        employee,
        businessId,
        customerId,
        customer,
        serviceId,
        service,
      ];

  Duration get duration => endDate.difference(startDate);
}
