import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationEntityStatusIndicator extends StatelessWidget {
  const ApplicationEntityStatusIndicator(
      {Key key, this.enabled, this.showIndicator = true, this.size = 6})
      : super(key: key);

  final bool enabled;
  final bool showIndicator;
  final double size;

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        showIndicator
            ? Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: enabled ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: SizedBox(
                      height: size,
                      width: size,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                ],
              )
            : SizedBox(),
        Text(
          SystemLang.LANG_MAP[enabled
              ? SystemText.ENTITY_STATUS_ACTIVE
              : SystemText.ENTITY_STATUS_INACTIVE][langIso639Code],
        ),
      ],
    );
  }
}
