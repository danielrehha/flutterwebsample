import 'package:allbert_cms/domain/entities/entity_business_settings.dart';
import 'package:meta/meta.dart';

class BusinessSettingsModel extends BusinessSettings {
  final String businessId;
  final String langIso639Code;
  final bool appointmentEmailsEnabled;
  final bool promotionalEmailsEnabled;
  final bool darkModeEnabled;
  final List<String> paymentMethods;

  BusinessSettingsModel({
    @required this.businessId,
    @required this.langIso639Code,
    @required this.appointmentEmailsEnabled,
    @required this.promotionalEmailsEnabled,
    @required this.darkModeEnabled,
    this.paymentMethods,
  });

  factory BusinessSettingsModel.getDefault(String businessId) {
    return BusinessSettingsModel(
      businessId: businessId,
      langIso639Code: "hu",
      appointmentEmailsEnabled: true,
      promotionalEmailsEnabled: true,
      darkModeEnabled: false,
      paymentMethods: ["A"],
    );
  }

  factory BusinessSettingsModel.fromJson(Map<String, dynamic> json) {
    return BusinessSettingsModel(
      businessId: json["businessId"],
      langIso639Code: json["langIso639Code"],
      appointmentEmailsEnabled: json["appointmentEmailsEnabled"],
      promotionalEmailsEnabled: json["promotionalEmailsEnabled"],
      darkModeEnabled: json["darkModeEnabled"],
      paymentMethods: json["paymentMethods"].toString().split(""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "businessId": this.businessId,
      "langIso639Code": this.langIso639Code,
      "appointmentEmailsEnabled": this.appointmentEmailsEnabled,
      "promotionalEmailsEnabled": this.promotionalEmailsEnabled,
      "darkModeEnabled": this.darkModeEnabled,
      "paymentMethods": this.paymentMethods.join(),
    };
  }
}
