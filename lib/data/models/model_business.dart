import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/data/models/model_business_address.dart';
import 'package:allbert_cms/data/models/model_business_contact.dart';
import 'package:allbert_cms/data/models/model_business_details.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/data/models/model_subscription_info.dart';
import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_business.dart';
import 'package:allbert_cms/domain/entities/entity_business_details.dart';
import 'package:meta/meta.dart';

import 'model_business_settings.dart';

class BusinessModel extends Business implements ISerializable<BusinessModel> {
  final String id;
  final String firebaseUid;
  final BusinessDetailsModel details;
  final BusinessAddressModel address;
  final BusinessContactModel contact;
  final List<ApplicationImageModel> portfolioImages;
  final ApplicationImageModel avatar;
  final SubscriptionInfoModel subscriptionInfo;
  final List<ServiceModel> services;
  final BusinessSettingsModel settings;
  final bool solo;
  final bool enabled;
  final bool deleted;

  BusinessModel({
    @required this.id,
    @required this.firebaseUid,
    this.details,
    this.address,
    this.contact,
    @required this.portfolioImages,
    @required this.avatar,
    @required this.subscriptionInfo,
    @required this.settings,
    @required this.services,
    @required this.solo,
    @required this.enabled,
    @required this.deleted,
  }) : super(
          id: id,
          firebaseUid: firebaseUid,
          details: details,
          address: address,
          contact: contact,
          portfolioImages: portfolioImages,
          avatar: avatar,
          subscriptionInfo: subscriptionInfo,
          settings: settings,
          services: services,
          solo: solo,
          enabled: enabled,
          deleted: deleted,
        );

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    List<ServiceModel> jsonServices = [];
    for (var service in json['services']) {
      jsonServices.add(ServiceModel.fromJson(service));
    }
    List<ApplicationImageModel> jsonPortfolioImages = [];
    for (var image in json["portfolioImages"]) {
      jsonPortfolioImages.add(ApplicationImageModel.fromJson(image));
    }
    return BusinessModel(
      id: json['id'],
      firebaseUid: json['firebaseUid'],
      //info: BusinessInfoModel.fromJson(json['businessInfo']),
      details: json["details"] == null
          ? null
          : BusinessDetailsModel.fromJson(json["details"]),
      address: json["address"] == null
          ? null
          : BusinessAddressModel.fromJson(json["address"]),
      contact: json["contact"] == null
          ? null
          : BusinessContactModel.fromJson(json["contact"]),
      portfolioImages: jsonPortfolioImages,
      avatar: json['avatar'] == null
          ? null
          : ApplicationImageModel.fromJson(json['avatar']),
      subscriptionInfo: json["subscriptionInfo"] == null
          ? null
          : SubscriptionInfoModel.fromJson(json['subscriptionInfo']),
      settings: json["businessSettings"] == null
          ? BusinessSettingsModel.getDefault(json["id"])
          : BusinessSettingsModel.fromJson(
              json["businessSettings"],
            ),
      services: json['services'] == null ? null : jsonServices,
      solo: json['solo'],
      enabled: json['enabled'],
      deleted: json['deleted'],
    );
  }

  BusinessModel copyWith({
    String id,
    String firebaseUid,
    BusinessDetailsModel details,
    BusinessAddressModel address,
    BusinessContactModel contact,
    List<ApplicationImageModel> portfolioImages,
    ApplicationImageModel avatar,
    SubscriptionInfoModel subscriptionInfo,
    BusinessSettingsModel settings,
    List<ServiceModel> services,
    bool solo,
    bool enabled,
    bool deleted,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      details: details ?? this.details,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      avatar: avatar ?? this.avatar,
      subscriptionInfo: subscriptionInfo ?? this.subscriptionInfo,
      settings: settings ?? this.settings,
      services: services ?? this.services,
      solo: solo ?? this.solo,
      enabled: enabled ?? this.enabled,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  BusinessModel fromJson(Map<String, dynamic> json) {
    return BusinessModel.fromJson(json);
  }
}
