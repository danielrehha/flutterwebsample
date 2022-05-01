import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TranslateTime {
  String call({@required DateTime time}) {
    if (time.minute < 10) {
      return "${time.hour}:0${time.minute}";
    }
    return "${time.hour}:${time.minute}";
  }

  String fromTime({@required TimeOfDay time}) {
    if (time.minute < 10) {
      return "${time.hour}:0${time.minute}";
    }
    return "${time.hour}:${time.minute}";
  }
}
