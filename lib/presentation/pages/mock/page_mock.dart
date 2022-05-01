import 'package:flutter/material.dart';

class MockPage extends StatelessWidget {
  const MockPage({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: child,
      ),
    );
  }
}
