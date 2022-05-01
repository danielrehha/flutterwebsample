import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'entity_service.dart';

class EmployeeService extends Equatable {
  final String employeeId;
  final String serviceId;
  final Service service;

  EmployeeService({
    @required this.employeeId,
    @required this.serviceId,
    @required this.service,
  });

  @override
  List<Object> get props => [
        employeeId,
        serviceId,
        service,
      ];
}
