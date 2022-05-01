import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Service extends Equatable {
  final String id;
  final String name;
  final double cost;
  final int duration;
  final String currency;
  final String businessId;
  final bool enabled;
  final DateTime createdOn;

  Service({
    @required this.id,
    @required this.name,
    @required this.cost,
    @required this.duration,
    @required this.currency,
    @required this.businessId,
    @required this.enabled,
    this.createdOn,
  });

  @override
  List<Object> get props => [
        id,
        name,
        cost,
        duration,
        currency,
        businessId,
        enabled,
        createdOn,
      ];
}
