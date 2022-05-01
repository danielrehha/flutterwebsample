import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnackBarActions {
  void dispatchErrorSnackBar(BuildContext context,
      {String message = null, String err = null}) {
    if (message == null) {
      final langIso639Code =
          Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
      message = SystemLang.LANG_MAP[SystemText.OPERATION_FAILED]
                      [langIso639Code] +
                  err ==
              null
          ? ""
          : " [${err}]";
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeColors[ThemeColor.pinkRed],
      ),
    );
  }

  void dispatchSuccessSnackBar(BuildContext context, {String message = null}) {
    if (message == null) {
      final langIso639Code =
          Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
      message =
          SystemLang.LANG_MAP[SystemText.OPERATION_SUCCESS][langIso639Code];
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void dispatchLoadingSnackBar(BuildContext context, {String message = null}) {
    if (message == null) {
      final langIso639Code =
          Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
      message =
          SystemLang.LANG_MAP[SystemText.OPERATION_IN_PROGRESS][langIso639Code];
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeColors[ThemeColor.orange],
      ),
    );
  }
}
