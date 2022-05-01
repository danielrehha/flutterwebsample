import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:flutter/material.dart';

class LoadingPageContent extends StatelessWidget {
  LoadingPageContent({
    Key key,
    this.loadingMessage = '',
    this.loadingIcon = const Icon(Icons.label),
  }) : super(key: key);

  final String loadingMessage;
  final Icon loadingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ApplicationLoadingIndicator(),
        ],
      ),
    );
  }
}
