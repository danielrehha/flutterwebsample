import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'entity_customer_info.dart';

class Customer extends Equatable {
  final String id;
  final CustomerInfo info;
  final ApplicationImage avatar;

  Customer({
    @required this.id,
    @required this.info,
    @required this.avatar,
  });

  @override
  List<Object> get props => [
        id,
        info,
        avatar,
      ];
}
