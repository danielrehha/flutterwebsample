import 'package:flutter/material.dart';

class ApplicationProvider extends ChangeNotifier {
  bool _canvasLoading;
  bool get canvasLoading => _canvasLoading;

  ApplicationProvider() {
    _canvasLoading = false;
  }

  void showCanvas() {
    _canvasLoading = true;
    notifyListeners();
  }

  void hideCanvas() {
    _canvasLoading = false;
    notifyListeners();
  }
}
