import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';

class RegistrationTabNavigator extends StatelessWidget {
  RegistrationTabNavigator({
    Key key,
    this.length,
    this.currentIndex,
    this.inactiveColor = Colors.grey,
    this.selectedColor = Colors.blue,
  }) : super(key: key);

  final int length;
  final int currentIndex;
  final Color inactiveColor;
  final Color selectedColor;
  final double size = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: index == currentIndex ? size : size / 1.3,
                  height: index == currentIndex ? size : size / 1.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color:
                        index == currentIndex ? selectedColor : inactiveColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
