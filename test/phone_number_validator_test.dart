import 'package:allbert_cms/core/utils/util_phone_number_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PhoneNumberValidator validator;
  setUp(() {
    validator = PhoneNumberValidator();
  });

  test("Validate Iso code with phone number", () {
    final result =
        validator.validateWithIso(countryCode: "HU", phoneNumber: "706136413");

    expect(result, true);
  });

  test("Reject result with Iso and phone number", () {
    final result =
        validator.validateWithIso(countryCode: "HU", phoneNumber: "7061364130");

    expect(result, false);
  });

  test("Validate raw phone number", () {
    final result = validator.validateWithCombined(phoneNumber: "+36706136413");

    expect(result, true);
  });

  test("Reject raw phone number", () {
    final result = validator.validateWithCombined(phoneNumber: "+3670613641");

    expect(result, false);
  });
}
