import 'package:allbert_cms/data/models/model_subscription.dart';
import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_subscription_info.dart';
import 'package:meta/meta.dart';

class SubscriptionInfoModel extends SubscriptionInfo implements ISerializable<SubscriptionInfoModel>{
  final String businessId;
  final DateTime createdOn;
  final DateTime endsOn;
  final bool doesRenew;
  final bool isTrial;
  final int subscriptionId;
  final SubscriptionModel subscription;

  SubscriptionInfoModel({
    @required this.businessId,
    @required this.createdOn,
    @required this.endsOn,
    @required this.doesRenew,
    @required this.isTrial,
    @required this.subscriptionId,
    @required this.subscription,
  });

  factory SubscriptionInfoModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfoModel(
      businessId: json['businessId'],
      createdOn: DateTime.parse(json['createdOn']),
      endsOn: DateTime.parse(json['endsOn']),
      doesRenew: json['doesRenew'],
      isTrial: json['isTrial'],
      subscriptionId: json['subscriptionId'],
      subscription: SubscriptionModel.fromJson(
        json['subscription'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessId': this.businessId,
      'createdOn': this.createdOn,
      'endsOn': this.endsOn,
      'doesRenew': this.doesRenew,
      'isTrial': this.isTrial,
      'subscriptionId': this.subscriptionId,
      'subscription': subscription.toJson(),
    };
  }

  SubscriptionInfoModel copyWith({
    String businessId,
    DateTime createdOn,
    DateTime endsOn,
    bool doesRenew,
    bool isTrial,
    int subscriptionId,
    SubscriptionModel subscription,
  }) {
    return SubscriptionInfoModel(
        businessId: businessId ?? this.businessId,
        createdOn: createdOn ?? this.createdOn,
        endsOn: endsOn ?? this.endsOn,
        doesRenew: doesRenew ?? this.doesRenew,
        isTrial: isTrial ?? this.isTrial,
        subscriptionId: subscriptionId ?? this.subscriptionId,
        subscription: subscription ?? this.subscription);
  }

  @override
  SubscriptionInfoModel fromJson(Map<String, dynamic> json) {
    return SubscriptionInfoModel.fromJson(json);
  }
}
