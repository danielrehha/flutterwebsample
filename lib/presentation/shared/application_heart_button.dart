import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ApplicationHeartButton extends StatelessWidget {
  ApplicationHeartButton({Key key, this.size = 35, this.value = false, @required this.onTap})
      : super(key: key);

  final double size;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Icon(
          value ? Ionicons.md_heart : Ionicons.md_heart_empty,
          color: getColor(),
          size: size,
        ),
      ),
      onTap: onTap,
    );
  }

  Color getColor() {
    if (value) {
      return themeColors[ThemeColor.pinkRed];
    }
    return Colors.black54;
  }
}
