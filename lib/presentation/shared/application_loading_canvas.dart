import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:flutter/material.dart';

class ApplicationLoadingCanvas extends StatelessWidget {
  const ApplicationLoadingCanvas({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ApplicationLoadingIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text("Please wait..."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
