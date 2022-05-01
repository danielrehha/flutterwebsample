import 'package:allbert_cms/domain/entities/entity_customer.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/domain/enums/enum_entity_type.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';

class ApplicationNullableEntityTextFactory {
  ApplicationNullableEntityTextFactory({Key key});

  TextStyle getTextStyle(dynamic obj) {
    EntityType entityType;
    if (obj is Employee) {
      entityType = EntityType.Employee;
    }
    if (obj is Service) {
      entityType = EntityType.Service;
    }
    if (obj is Customer) {
      entityType = EntityType.Customer;
    }
    if (isNull(entityType, obj)) {
      return bodyStyle_2_grey;
    }
    return bodyStyle_2;
  }

  bool isNull(EntityType entityType, dynamic obj) {
    switch (entityType) {
      case EntityType.Customer:
        final customer = obj as Customer;
        if (customer == null || customer.info == null) {
          return true;
        }
        if (customer.info.firstName == null || customer.info.lastName == null) {
          return true;
        }
        if (customer.info.firstName.isEmpty || customer.info.lastName.isEmpty) {
          return true;
        }
        return false;
        break;
      case EntityType.Employee:
        final employee = obj as Employee;
        if (employee == null) {
          return true;
        }
        if (employee.info == null) {
          return true;
        }
        if (employee.info.firstName == null || employee.info.lastName == null) {
          return true;
        }
        if (employee.info.firstName.isEmpty || employee.info.lastName.isEmpty) {
          return true;
        }
        return false;
        break;
      case EntityType.Service:
        final service = obj as Service;
        if (service == null) {
          return true;
        }
        return false;
        break;
      default:
        return true;
        break;
    }
  }
}
