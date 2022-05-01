import 'package:allbert_cms/domain/enums/enum_entity_status.dart';
import 'package:allbert_cms/domain/enums/enum_entity_type.dart';
import 'package:meta/meta.dart';

class EnumConvert {
  String entityStatusToString({@required EntityStatus status}) {
    if (status == EntityStatus.Active) {
      return "active";
    }
    return "paused";
  }

  String entityTypeToString({@required EntityType type}) {
    if (type == EntityType.Customer) {
      return "customer";
    }
    if (type == EntityType.Business) {
      return "business";
    }
    if (type == EntityType.Employee) {
      return "employee";
    }
    return "service";
  }
}
