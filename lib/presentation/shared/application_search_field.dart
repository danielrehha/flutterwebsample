import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ApplicationSearchField extends StatelessWidget {
  const ApplicationSearchField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(250, 250, 250, 0.4),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                spreadRadius: 0.5,
                offset: Offset(1.0, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Feather.search,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Keresés",
              style: bodyStyle_1_white,
            ),
            /* Expanded(
              child: TextField(
                style: bodyStyle_1,
                decoration: InputDecoration(
                    hintText: "", counterText: "", border: InputBorder.none),
                textAlignVertical: TextAlignVertical.top,
              ),
            ) */
          ],
        ),
      ),
    );
  }
}
