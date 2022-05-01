import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _langIso639Code;

  String get langIso639Code => _langIso639Code ?? "en";

  void setLang({@required String langIso639Code}) {
    _langIso639Code = langIso639Code;
    notifyListeners();
  }

  void reset() {
    _langIso639Code = null;
  }
}
