import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';

typedef SelectCountryCodeCallback = void Function(String);
typedef ChangePhoneNumberCallback = void Function(String);

class ApplicationPhoneNumberField extends StatelessWidget {
  ApplicationPhoneNumberField({
    Key key,
    @required this.controller,
    @required this.error,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.maxLength = 20,
    this.hintText = '12 345 6789',
    this.countryCode = 'hu',
    this.countryCodeCallback,
    this.onChanged,
  }) : super(key: key);

  final SelectCountryCodeCallback countryCodeCallback;
  final String countryCode;
  final TextEditingController controller;
  final bool error;
  final TextAlign textAlign;
  final bool readOnly;
  final int maxLength;
  final String hintText;
  final Border errorBorder = Border.all(color: Colors.red, width: 1);
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: themeColors[ThemeColor.hollowGrey],
          borderRadius: BorderRadius.circular(30),
          border: error ? errorBorder : null,
        ),
        child: Row(
          children: [
            CountryCodePicker(
              textStyle: bodyStyle_1,
              showFlag: true,
              initialSelection: countryCode,
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
