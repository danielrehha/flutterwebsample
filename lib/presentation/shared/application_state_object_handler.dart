import 'package:flutter/material.dart';

import 'application_shimmer_container.dart';

class ApplicationStateObjectHandler extends StatelessWidget {
  const ApplicationStateObjectHandler({
    Key key,
    this.isLoading,
    this.errorMessage,
    this.stateObject,
  }) : super(key: key);

  final bool isLoading;
  final String errorMessage;
  final Widget stateObject;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Expanded(child: ApplicationShimmerContainer());
    }
    if (errorMessage != null) {
      return Text(errorMessage);
    }
    return stateObject;
  }
}
