import 'package:allbert_cms/data/models/model_customer.dart';
import 'package:meta/meta.dart';

class CustomerDetailsDto {
  final int totalAppointmentCount;
  final int uncompletedAppointmentCount;
  final double appointmentCompletionIndex;
  final CustomerModel customer;

  CustomerDetailsDto({
    @required this.totalAppointmentCount,
    @required this.uncompletedAppointmentCount,
    @required this.appointmentCompletionIndex,
    @required this.customer,
  });

  factory CustomerDetailsDto.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsDto(
      totalAppointmentCount: json["totalAppointmentCount"],
      uncompletedAppointmentCount: json["unCompletedAppointmentCount"],
      appointmentCompletionIndex: json["appointmentCompletionIndex"],
      customer: json["customer"] == null
          ? null
          : CustomerModel.fromJson(json["customer"]),
    );
  }
}
