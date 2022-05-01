import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_phone_number_validator.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeUtils {
  SnackBarActions snackBarActions;
  PhoneNumberValidator phoneNumberValidator;
  IApiDataSource dataSource;

  EmployeeUtils() {
    this.snackBarActions = SnackBarActions();
    this.phoneNumberValidator = PhoneNumberValidator();
    this.dataSource = ApiDataSource();
  }

  bool isInfoValid(BuildContext ctx,
      {@required String firstName,
      @required String lastName,
      @required String job,
      @required String description,
      @required String phone,
      @required String email,
      @required String selectedIsoCode}) {
    final langIso639Code =
        Provider.of<LanguageProvider>(ctx, listen: false).langIso639Code;
    bool showError = false;
    String fieldName = "field";
    String errorMessage =
        SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code];
    if (firstName.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.FIRST_NAME][langIso639Code];
    }
    if (lastName.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.LAST_NAME][langIso639Code];
    }
    if (job.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.JOB][langIso639Code];
    }
    if (phone.isNotEmpty &&
        !phoneNumberValidator.validateWithIso(
            countryCode: selectedIsoCode, phoneNumber: phone)) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.PHONE_NUMBER][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.IS_NOT_VALID][langIso639Code];
    }
    if (phone.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.PHONE_NUMBER][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code];
    }
    if (email.isNotEmpty && !EmailValidator.validate(email)) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.EMAIL][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.IS_NOT_VALID][langIso639Code];
    }
    if (email.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.EMAIL][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code];
    }
    if (showError) {
      snackBarActions.dispatchErrorSnackBar(ctx,
          message: "$fieldName $errorMessage");
    }
    return !showError;
  }

  Future<bool> uploadEmployeeAvatarAsync(BuildContext context, String employeeId, PlatformFile file) async {
    try {
      await dataSource.uploadEmployeeAvatarImageAsync(
          employeeId: employeeId, file: file);
      return true;
    } on ServerException catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      snackBarActions
          .dispatchErrorSnackBar(context, err: e.toString());
    }
    return false;
  }

    Future<bool> deleteEmployeeAvatarAsync(BuildContext context, String employeeId) async {
    try {
      await dataSource.deleteEmployeeAvatarImageAsync(
          employeeId: employeeId);
      return true;
    } on ServerException catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      snackBarActions
          .dispatchErrorSnackBar(context, err: e.toString());
    }
    return false;
  }
}
