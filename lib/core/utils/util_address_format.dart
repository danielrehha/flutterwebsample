import 'package:meta/meta.dart';

class AddressFormat {
  String call(
      {String country,
      @required String city,
      @required String streetName,
      @required String streetType,
      @required String streetNumber,
      @required String zip}) {
    return "$zip $city, $streetName $streetType $streetNumber.";
  }
}
