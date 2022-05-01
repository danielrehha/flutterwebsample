import 'package:meta/meta.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneDialcodeParser {
  String call({@required String phoneNumber, String isoCode}) {
    final combinedPhoneNumber = PhoneNumber.fromIsoCode(isoCode, phoneNumber);
    final dialCode = combinedPhoneNumber.dialCode;
    return dialCode;
  }

  String international({@required String phoneNumber, String isoCode}) {
    return PhoneNumber.fromIsoCode(isoCode, phoneNumber).international;
  }
}
