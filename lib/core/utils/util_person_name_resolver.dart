import 'package:meta/meta.dart';

class PersonNameResolver {
  String cultureBasedResolve({
    @required String firstName,
    @required String lastName,
    String langIso639Code = "HU",
  }) {
    if (langIso639Code == "HU") {
      return "$lastName $firstName";
    }
    return "$firstName $lastName";
  }
}
