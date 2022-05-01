import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';

typedef SelectCountryCodeCallback = void Function(String);
typedef ChangePhoneNumberCallback = void Function(String);

class PhoneNumberField extends StatelessWidget {
  PhoneNumberField({
    Key key,
    @required this.controller,
    this.error = false,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.maxLength = 20,
    this.hintText = 'xxyyyzzzz',
    this.selectedPhoneIsoCode = 'hu',
    this.countryCodeCallback,
    this.onChanged,
    this.bottomPadding = 0,
    this.topPadding = 10,
  }) : super(key: key);

  final SelectCountryCodeCallback countryCodeCallback;
  final String selectedPhoneIsoCode;
  final TextEditingController controller;
  final bool error;
  final TextAlign textAlign;
  final bool readOnly;
  final int maxLength;
  final String hintText;
  final Border errorBorder = Border.all(color: Colors.red, width: 1);
  final Function(String) onChanged;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            //border: getError() ? errorBorder : null,
            boxShadow: [inputBoxShadow]),
        child: Row(
          children: [
            CountryCodePicker(
              initialSelection: selectedPhoneIsoCode,
              onChanged: (value) {
                countryCodeCallback(value.code);
              },
            ),
            Expanded(
              child: TextField(
                readOnly: readOnly,
                textAlign: textAlign,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  hintText: hintText,
                  counterText: '',
                ),
                maxLength: maxLength,
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
