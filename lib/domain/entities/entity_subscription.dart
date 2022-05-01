import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Subscription extends Equatable {
  final int id;
  final String name;
  final int maxEmployees;
  final int maxServices;
  final double cost;
  final String costCurrency;

  Subscription({
    @required this.id,
    @required this.name,
    @required this.maxEmployees,
    @required this.maxServices,
    @required this.cost,
    @required this.costCurrency,
  });

  @override
  List<Object> get props => [
        id,
        name,
        maxEmployees,
        maxServices,
        cost,
        costCurrency,
      ];
}
