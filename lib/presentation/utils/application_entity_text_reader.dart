import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/domain/entities/entity_customer.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationEntityTextReader {
  PersonNameResolver _personNameResolver;

  ApplicationEntityTextReader() {
    _personNameResolver = PersonNameResolver();
  }
  String serviceName(BuildContext context, Service service,
      {bool nullable = true}) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    if (service == null) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    return service.name ??
        SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
  }

  String employeeName(BuildContext context, Employee employee,
      {bool nullable = true}) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    if (employee == null) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    if (employee.info == null) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    if (employee.info.firstName == null || employee.info.lastName == null) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    if (employee.info.firstName.isEmpty || employee.info.lastName.isEmpty) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    return _personNameResolver.cultureBasedResolve(
      firstName: employee.info.firstName,
      lastName: employee.info.lastName,
      langIso639Code: langIso639Code,
    );
  }

  String customerName(BuildContext context, Customer customer, {bool nullable = true}) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    if (customer == null) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    if (customer.info == null) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    if (customer.info.firstName == null || customer.info.lastName == null) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    if (customer.info.firstName.isEmpty || customer.info.lastName.isEmpty) {
      return nullable
          ? SystemLang.LANG_MAP[SystemText.DELETED][langIso639Code]
          : SystemLang.LANG_MAP[SystemText.NOT_FOUND][langIso639Code];
    }
    return _personNameResolver.cultureBasedResolve(
      firstName: customer.info.firstName,
      lastName: customer.info.lastName,
      langIso639Code: langIso639Code,
    );
  }
}
