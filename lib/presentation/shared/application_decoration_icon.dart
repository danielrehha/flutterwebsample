import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ApplicationDecorationIcon extends StatelessWidget {
  ApplicationDecorationIcon({
    Key key,
    this.icon = Ionicons.ios_star,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.size = 14,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: size,
            color: iconColor,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
