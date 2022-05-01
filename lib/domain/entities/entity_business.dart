import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_business_address.dart';
import 'package:allbert_cms/domain/entities/entity_business_contact.dart';
import 'package:allbert_cms/domain/entities/entity_business_details.dart';
import 'package:allbert_cms/domain/entities/entity_business_settings.dart';
import 'package:equatable/equatable.dart';
import 'entity_subscription_info.dart';
import 'entity_service.dart';
import 'package:meta/meta.dart';

class Business extends Equatable {
  final String id;
  final String firebaseUid;
  final BusinessDetails details;
  final BusinessAddress address;
  final BusinessContact contact;
  final List<ApplicationImage> portfolioImages;
  final ApplicationImage avatar;
  final SubscriptionInfo subscriptionInfo;
  final List<Service> services;
  final BusinessSettings settings;
  final bool solo;
  final bool enabled;
  final bool deleted;

  Business({
    @required this.id,
    @required this.firebaseUid,
    this.details,
    this.address,
    this.contact,
    @required this.portfolioImages,
    @required this.avatar,
    @required this.subscriptionInfo,
    this.settings,
    @required this.services,
    @required this.solo,
    @required this.enabled,
    @required this.deleted,
  });

  @override
  List<Object> get props => [
        id,
        details,
        address,
        contact,
        portfolioImages,
        avatar,
        subscriptionInfo,
        settings,
        services,
        solo,
        enabled,
        deleted,
      ];
}
