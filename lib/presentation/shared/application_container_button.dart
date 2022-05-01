import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';

class ApplicationContainerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;
  final bool disabled;
  final Color color;
  final Color textColor;
  final Color defaultColor = themeColors[ThemeColor.pinkRed];
  final FontWeight fontWeight;
  final double height;
  final double borderRadius;
  final bool loadingOnDisabled;
  final Color disabledTextColor;
  final Color disabledColor;
  final Color loadingIndicatorColor;
  final double fontSize;

  ApplicationContainerButton({
    Key key,
    this.disabled = false,
    this.color,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.bold,
    this.label = "Button",
    this.onPress,
    this.height = 40,
    this.borderRadius = 100,
    this.loadingOnDisabled = false,
    this.disabledTextColor = Colors.grey,
    this.disabledColor = const Color.fromRGBO(10, 10, 10, 0.09),
    this.loadingIndicatorColor = Colors.white,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: disabled
              ? disabledColor ?? Color.fromRGBO(10, 10, 10, 0.09)
              : (color ?? defaultColor),
        ),
        child: loadingOnDisabled && disabled
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height / 2,
                    width: height / 2,
                    child: ApplicationLoadingIndicator(
                      color: loadingIndicatorColor,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: disabled ? disabledTextColor : textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
      onTap: disabled ? () {} : onPress,
    );
  }
}
