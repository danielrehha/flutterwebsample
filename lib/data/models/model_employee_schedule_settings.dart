import 'package:allbert_cms/domain/entities/entity_employee_settings.dart';
import 'package:meta/meta.dart';

class EmployeeSettingsModel extends EmployeeSettings {
  final String employeeId;
  final int allowedBookingFrequencyInMinutes;
  final int allowedAppointmentDeletionDeadlineInHours;
  final int allowedAppointmentCreationDeadlineInHours;
  final int minAllowedCustomerBookingIndex;

  EmployeeSettingsModel({
    @required this.employeeId,
    @required this.allowedBookingFrequencyInMinutes,
    @required this.allowedAppointmentDeletionDeadlineInHours,
    @required this.allowedAppointmentCreationDeadlineInHours,
    @required this.minAllowedCustomerBookingIndex,
  }) : super(
          employeeId: employeeId,
          allowedBookingFrequencyInMinutes: allowedBookingFrequencyInMinutes,
          allowedAppointmentDeletionDeadlineInHours:
              allowedAppointmentDeletionDeadlineInHours,
          allowedAppointmentCreationDeadlineInHours:
              allowedAppointmentCreationDeadlineInHours,
          minAllowedCustomerBookingIndex: minAllowedCustomerBookingIndex,
        );

  factory EmployeeSettingsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeSettingsModel(
      employeeId: json["employeeId"],
      allowedBookingFrequencyInMinutes:
          json["allowedBookingFrequencyInMinutes"],
      allowedAppointmentDeletionDeadlineInHours:
          json["allowedAppointmentDeletionDeadlineInHours"],
      allowedAppointmentCreationDeadlineInHours:
          json["allowedAppointmentCreationDeadlineInHours"],
      minAllowedCustomerBookingIndex: json["minAllowedCustomerBookingIndex"],
    );
  }

  factory EmployeeSettingsModel.getDefault(String employeeId) {
    return EmployeeSettingsModel(
      employeeId: employeeId,
      allowedBookingFrequencyInMinutes: 30,
      allowedAppointmentDeletionDeadlineInHours: 1,
      allowedAppointmentCreationDeadlineInHours: 1,
      minAllowedCustomerBookingIndex: 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "employeeId": this.employeeId,
      "allowedBookingFrequencyInMinutes": this.allowedBookingFrequencyInMinutes,
      "allowedAppointmentDeletionDeadlineInHours":
          this.allowedAppointmentDeletionDeadlineInHours,
      "allowedAppointmentCreationDeadlineInHours":
          this.allowedAppointmentCreationDeadlineInHours,
      "minAllowedCustomerBookingIndex": this.minAllowedCustomerBookingIndex,
    };
  }
}
