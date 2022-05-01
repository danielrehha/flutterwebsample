import 'package:flutter/material.dart';

class ApplicationActivityIndicator extends StatelessWidget {
  const ApplicationActivityIndicator({Key key, @required this.activityCount})
      : super(key: key);

  final int activityCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.red[700],
      ),
      child: Center(
        child: Text(
          activityCount.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
