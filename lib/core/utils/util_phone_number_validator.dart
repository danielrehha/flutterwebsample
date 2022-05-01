import 'package:meta/meta.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneNumberValidator {
  bool validateWithIso(
      {@required String countryCode, @required String phoneNumber}) {
    final combinedPhoneNumber =
        PhoneNumber.fromIsoCode(countryCode, phoneNumber);

    return combinedPhoneNumber.validate(PhoneNumberType.mobile);
  }

  bool validateWithCombined({@required String phoneNumber}) {
    final parsedPhoneNumber = PhoneNumber.fromRaw(phoneNumber);

    return parsedPhoneNumber.validate(PhoneNumberType.mobile);
  }
}
