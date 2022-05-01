import 'package:allbert_cms/domain/entities/entity_subscription.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SubscriptionInfo extends Equatable {
  final String businessId;
  final DateTime createdOn;
  final DateTime endsOn;
  final bool doesRenew;
  final bool isTrial;
  final int subscriptionId;
  final Subscription subscription;

  SubscriptionInfo({
    @required this.businessId,
    @required this.createdOn,
    @required this.endsOn,
    @required this.doesRenew,
    @required this.isTrial,
    @required this.subscriptionId,
    @required this.subscription,
  });

  @override
  List<Object> get props => [
        businessId,
        createdOn,
        endsOn,
        doesRenew,
        isTrial,
        subscriptionId,
        subscription,
      ];
}
