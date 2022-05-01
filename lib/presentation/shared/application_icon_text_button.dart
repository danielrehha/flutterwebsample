import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ApplicationIconTextButton extends StatelessWidget {
  ApplicationIconTextButton({
    Key key,
    @required this.onTap,
    @required this.label,
    this.textColor = Colors.white,
    this.color = Colors.black,
    this.icon = Ionicons.ios_add,
    this.enabled = true,
    this.iconSize = 16,
    this.textSize = 14,
  }) : super(key: key);

  final VoidCallback onTap;
  final String label;
  final Color textColor;
  final Color color;
  final IconData icon;
  final bool enabled;
  final double iconSize;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              icon == null
                  ? SizedBox()
                  : Row(
                      children: [
                        Icon(
                          icon,
                          color: getStateColor(textColor),
                          size: iconSize,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
              Text(
                label,
                style: TextStyle(
                  color: getStateColor(textColor),
                  fontSize: textSize,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Color getStateColor(Color color) {
    if (enabled) {
      return color;
    }
    return color.withOpacity(0.5);
  }
}
