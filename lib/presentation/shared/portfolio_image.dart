import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:flutter/material.dart';

typedef OnDeleteImageCallback = Function(ApplicationImage);

class PortfolioImage extends StatelessWidget {
  PortfolioImage(
      {Key key, @required this.image, @required this.onDeleteCallback})
      : super(key: key);

  final ApplicationImage image;
  final OnDeleteImageCallback onDeleteCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.topCenter,
                    image: NetworkImage(
                      image.pathUrl,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white54,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: InkWell(
              child: Icon(
                Icons.delete,
              ),
              onTap: () {
                onDeleteCallback(image);
              },
            ),
          ),
        ),
      ],
    );
  }
}
