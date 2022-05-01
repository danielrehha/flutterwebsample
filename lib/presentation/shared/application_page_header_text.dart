import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationPageHeaderText extends StatelessWidget {
  const ApplicationPageHeaderText({Key key, @required this.label})
      : super(key: key);

  final SystemText label;

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Text(
      SystemLang.LANG_MAP[label][langIso639Code],
      style: headerStyle_2_bold,
      textAlign: TextAlign.start,
    );
  }
}
