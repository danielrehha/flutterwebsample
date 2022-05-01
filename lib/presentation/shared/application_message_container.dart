import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';

class ApplicationMessageContainer extends StatelessWidget {
  const ApplicationMessageContainer(
      {Key key,
      @required this.assetImageName,
      @required this.headerLabel,
      this.subtextLabel = "",
      this.imageHeight = 300})
      : super(key: key);

  final String assetImageName;
  final String headerLabel;
  final String subtextLabel;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: imageHeight,
          child: Image(
            image: Image.asset(assetImageName).image,
            fit: BoxFit.fitHeight,
          ),
        ),
        Text(
          headerLabel,
          style: headerStyle_2_bold,
          textAlign: TextAlign.center,
        ),
        subtextLabel.isEmpty
            ? SizedBox()
            : Text(
                subtextLabel,
                style: bodyStyle_1,
              ),
      ],
    );
  }
}
