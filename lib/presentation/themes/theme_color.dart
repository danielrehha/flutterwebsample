import 'package:flutter/material.dart';

const Color lightGrey = Color.fromRGBO(10, 10, 10, 0.05);

const Color shimmerColor = Color.fromRGBO(10, 10, 10, 0.005);

enum ThemeColor {
  blue,
  lightBlue,
  purple,
  orange,
  yellowAmber,
  pinkRed,
  hollowGrey,
}

const Map<ThemeColor, Color> themeColors = {
  ThemeColor.blue: Color(0xff085cfd),
  ThemeColor.lightBlue: Color(0xffd8effc),
  ThemeColor.purple: Color(0xff7161f1),
  ThemeColor.orange: Color(0xffeb7b60),
  ThemeColor.yellowAmber: Color(0xfff1c061),
  ThemeColor.pinkRed: Color(0xfff16180),
  ThemeColor.hollowGrey: Color.fromRGBO(10, 10, 10, 0.03),
};

const Color shadowColor = Color.fromRGBO(10, 10, 10, 0.03);

const double defaultShadowBlurRadius = 2.1;
const double defaultShadowSpreadRadius = 0.08;
const int defaultShadowAlpha = 35;

const BoxShadow inputBoxShadow = BoxShadow(
  blurRadius: 5, //15
  spreadRadius: 0.4, //0.8
  color: Colors.black12,
);
