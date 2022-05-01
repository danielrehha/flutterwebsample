import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';

// ignore: camel_case_types
class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Padding(
      padding: defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_BILLING]
                    [langIso639Code],
                style: headerStyle_2_bold,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
