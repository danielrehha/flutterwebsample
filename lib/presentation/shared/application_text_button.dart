import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';

class ApplicationTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;
  final bool disabled;
  final Color color;
  final Color defaultColor = themeColors[ThemeColor.blue];
  final FontWeight fontWeight;
  final double fontSize;
  final TextDecoration underline;

  ApplicationTextButton({
    Key key,
    this.disabled = false,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.label = "Button",
    this.onPress,
    this.fontSize,
    this.underline = TextDecoration.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        label,
        style: TextStyle(
          color: disabled ? Colors.grey : (color ?? defaultColor),
          fontWeight: fontWeight,
          fontSize: fontSize,
          decoration: underline,
        ),
      ),
      onTap: disabled ? () {} : onPress,
    );
  }
}
