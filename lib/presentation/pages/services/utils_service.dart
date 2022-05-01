import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class ServiceUtils {
  SnackBarActions snackBarActions = SnackBarActions();

  bool isInfoValid(
    BuildContext context, {
    @required String name,
    @required String cost,
    @required String duration,
  }) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    bool showError = false;
    String fieldName = "field";
    String errorMessage =
        SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code];
    if (name.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.SERVICE_NAME][langIso639Code];
    }
    if (cost.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.SERVICE_COST][langIso639Code];
    }
    if (duration.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.SERVICE_DURATION][langIso639Code];
    }
    if (showError) {
      snackBarActions.dispatchErrorSnackBar(context,
          message: "$fieldName $errorMessage");
    }
    return !showError;
  }
}
