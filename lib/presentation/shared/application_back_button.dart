import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ApplicationBackButton extends StatelessWidget {
  const ApplicationBackButton(
      {Key key,
      @required this.onTap,
      this.color = Colors.black,
      this.icon = Ionicons.ios_arrow_back})
      : super(key: key);

  final VoidCallback onTap;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Icon(
          icon,
          color: color,
        ),
        onTap: onTap,
      ),
    );
  }
}
