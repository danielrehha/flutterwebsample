import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BusinessSettings extends Equatable {
  final String businessId;
  final String langIso639Code;
  final bool appointmentEmailsEnabled;
  final bool promotionalEmailsEnabled;
  final bool darkModeEnabled;
  final List<String> paymentMethods;

  BusinessSettings({
    @required this.businessId,
    @required this.langIso639Code,
    @required this.appointmentEmailsEnabled,
    @required this.promotionalEmailsEnabled,
    @required this.darkModeEnabled,
    this.paymentMethods,
  });

  @override
  List<Object> get props => [
        businessId,
        langIso639Code,
        appointmentEmailsEnabled,
        promotionalEmailsEnabled,
        darkModeEnabled,
        paymentMethods,
      ];
}
