import 'package:meta/meta.dart';

class EmailMatchVerification {
  bool call({@required String value1, String value2}) {
    if (value1 == value2) {
      return true;
    } else {
      return false;
    }
  }
}
