import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/pages/statistics/widgets/widget_statistics_appointments.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key key}) : super(key: key);

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
                SystemLang.LANG_MAP[SystemText.STATISTICS][langIso639Code],
                style: headerStyle_2_bold,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(child: AppointmentStatisticsWidget()),
        ],
      ),
    );
  }
}
