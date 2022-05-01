import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

typedef OnCheckBoxChanged = Function(bool);

class ApplicationCheckBox extends StatelessWidget {
  ApplicationCheckBox({
    Key key,
    @required this.onTap,
    this.size = 18,
    @required this.value,
    this.activeColor = Colors.orange,
    this.inactiveColor = Colors.white,
    this.iconData = Feather.check,
  }) : super(key: key);

  final double size;
  final bool value;
  final Color activeColor;
  final Color inactiveColor;
  final IconData iconData;
  final OnCheckBoxChanged onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: value ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(6),
            /*           border: value
                ? Border.all(
                    color: Colors.transparent,
                  )
                : Border.all(color: Colors.black54, width: 1.5), */
            boxShadow: [
              BoxShadow(
                color: themeColors[ThemeColor.hollowGrey].withAlpha(35),
                blurRadius: 3,
                spreadRadius: 0.4,
              ),
            ]),
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            iconData,
            color: value ? Colors.white : Colors.transparent,
            size: size * 0.8,
          ),
        ),
      ),
      onTap: () {
        onTap(!value);
      },
    );
  }
}
