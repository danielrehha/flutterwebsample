import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class EmployeeSettings extends Equatable {
  final String employeeId;
  final int allowedBookingFrequencyInMinutes;
  final int allowedAppointmentDeletionDeadlineInHours;
  final int allowedAppointmentCreationDeadlineInHours;
  final int minAllowedCustomerBookingIndex;

  EmployeeSettings({
    @required this.employeeId,
    @required this.allowedBookingFrequencyInMinutes,
    @required this.allowedAppointmentDeletionDeadlineInHours,
    @required this.allowedAppointmentCreationDeadlineInHours,
    @required this.minAllowedCustomerBookingIndex,
  });

  @override
  List<Object> get props => [
        employeeId,
        allowedBookingFrequencyInMinutes,
        allowedAppointmentDeletionDeadlineInHours,
        allowedAppointmentCreationDeadlineInHours,
        minAllowedCustomerBookingIndex,
      ];
}
