import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CustomerListViewHeaderWidget extends StatelessWidget {
  const CustomerListViewHeaderWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        boxShadow: [
          BoxShadow(
            blurRadius: defaultShadowBlurRadius,
            spreadRadius: defaultShadowSpreadRadius,
            color: themeColors[ThemeColor.hollowGrey]
                .withAlpha(defaultShadowAlpha),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              child: Text(
                "Név",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: 150,
              child: Text(
                "Foglalások száma",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 150,
              child: Text(
                "Státusz",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 50,
              child: Icon(
                Entypo.dots_three_vertical,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
