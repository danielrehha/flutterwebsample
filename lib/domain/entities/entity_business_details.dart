import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BusinessDetails extends Equatable {
  final String businessId;
  final String name;
  final String type;
  final String description;

  BusinessDetails({
    @required this.businessId,
    @required this.name,
    @required this.type,
    @required this.description,
  });

  @override
  List<Object> get props => [
        businessId,
        name,
        type,
        description,
      ];
}
