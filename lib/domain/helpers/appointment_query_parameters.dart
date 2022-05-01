import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/domain/utils/utils_appointment.dart';

class AppointmentQueryParameters {
  final int pageNumber;
  final int pageSize;
  final String employeeId;
  final AppointmentStatus status;
  final String customerFlair;
  final String serviceId;
  final DateTime date;
  final bool orderByDescending;

  final AppointmentUtils utils = AppointmentUtils();

  AppointmentQueryParameters({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.employeeId,
    this.status,
    this.customerFlair,
    this.serviceId,
    this.date,
    this.orderByDescending,
  });
}
