import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({Key key}) : super(key: key);

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
                SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_DASHBOARD]
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
