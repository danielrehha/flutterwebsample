import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_subscription.dart';
import 'package:meta/meta.dart';

class SubscriptionModel extends Subscription implements ISerializable<SubscriptionModel>{
  final int id;
  final String name;
  final int maxEmployees;
  final int maxServices;
  final double cost;
  final String costCurrency;

  SubscriptionModel({
    @required this.id,
    @required this.name,
    @required this.maxEmployees,
    @required this.maxServices,
    @required this.cost,
    @required this.costCurrency,
  }) : super(
          id: id,
          name: name,
          maxEmployees: maxEmployees,
          maxServices: maxServices,
          cost: cost,
          costCurrency: costCurrency,
        );

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      name: json['name'],
      maxEmployees: json['maxEmployees'],
      maxServices: json['maxServices'],
      cost: json['cost'],
      costCurrency: json['costCurrency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'maxEmployees': this.maxEmployees,
      'maxServices': this.maxServices,
      'cost': this.cost,
      'costCurrency': this.costCurrency,
    };
  }

  @override
  SubscriptionModel fromJson(Map<String, dynamic> json) {
    return SubscriptionModel.fromJson(json);
  }
}
