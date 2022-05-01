import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

typedef ErrorHandlerCallback = void Function();

class ErrorContainer extends StatelessWidget {
  ErrorContainer({
    Key key,
    @required this.failure,
    @required this.errorHandlerCallback,
  }) : super(key: key);

  final Failure failure;
  final ErrorHandlerCallback errorHandlerCallback;

  final double lineSpacing = 12;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Ionicons.md_sad,
            size: 32,
          ),
          SizedBox(
            height: lineSpacing,
          ),
          Text(
            'Uh oh, hiba történt a művelet során',
            style: headerStyle_3_bold,
          ),
          SizedBox(
            height: lineSpacing,
          ),
          Text('Részletek: ${failure.errorMessage}'),
          SizedBox(
            height: lineSpacing,
          ),
          InkWell(
            child: Text(
              'Frissítés',
              style: TextStyle(
                color: themeColors[ThemeColor.blue],
              ),
            ),
            onTap: () {
              errorHandlerCallback();
            },
          )
        ],
      ),
    );
  }
}
