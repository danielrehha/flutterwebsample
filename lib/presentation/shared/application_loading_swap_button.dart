import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:flutter/material.dart';

class ApplicationLoadingSwapButton extends StatelessWidget {
  const ApplicationLoadingSwapButton(
      {Key key, @required this.isLoading, this.button})
      : super(key: key);

  final bool isLoading;
  final ApplicationTextButton button;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: isLoading
          ? ApplicationLoadingIndicator(
              type: IndicatorType.JumpingDots,
            )
          : button,
    );
  }
}
