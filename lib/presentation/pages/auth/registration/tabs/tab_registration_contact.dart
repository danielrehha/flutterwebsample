import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_phone_number_validator.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_business_contact.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/util_registration.dart';
import 'package:allbert_cms/presentation/pages/auth/settings_auth.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/shared/widget_phone_number_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget_registration_tabs_navigator.dart';

class RegistrationContactTab extends StatefulWidget {
  RegistrationContactTab({Key key}) : super(key: key);

  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();
  final PhoneNumberValidator phoneNumberValidator = PhoneNumberValidator();
  final RegistrationUtil registrationUtil = RegistrationUtil();

  @override
  _RegistrationContactTabState createState() => _RegistrationContactTabState();
}

class _RegistrationContactTabState extends State<RegistrationContactTab> {
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  String selectedPhoneIsoCode;

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    selectedPhoneIsoCode = "hu";
  }

  bool validateFields(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    bool error = false;
    String fieldName = "Field";
    String errorMessage =
        SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code];
    if (firstNameController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.FIRST_NAME][langIso639Code];
    }
    if (lastNameController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.LAST_NAME][langIso639Code];
    }
    if (phoneController.text.isNotEmpty &&
        !widget.phoneNumberValidator.validateWithIso(
            countryCode: selectedPhoneIsoCode,
            phoneNumber: phoneController.text)) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.PHONE_NUMBER][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.IS_NOT_VALID][langIso639Code];
    }
    if (phoneController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.PHONE_NUMBER][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code];
    }
    if (emailController.text.isNotEmpty &&
        !EmailValidator.validate(emailController.text)) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.EMAIL][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.IS_NOT_VALID][langIso639Code];
    }
    if (emailController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.EMAIL][langIso639Code];
      errorMessage =
          SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code];
    }
    if (error) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: "$fieldName $errorMessage");
    }
    return !error;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0,
            child: Container(
              width: 100,
              child: RegistrationTabNavigator(
                selectedColor: themeColors[ThemeColor.blue],
                inactiveColor: themeColors[ThemeColor.hollowGrey],
                currentIndex: 1,
                length: 5,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  SystemLang.LANG_MAP[SystemText.CONTACT_DETAILS]
                      [langIso639Code],
                  style: headerStyle_1_bold,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 1000,
                  child: Text(
                    SystemLang.LANG_MAP[SystemText.CONTACT_DETAILS_HINT]
                        [langIso639Code],
                    style: bodyStyle_2_grey,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: defaultColumnWidth * 2 + 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              SystemLang.LANG_MAP[SystemText.FIRST_NAME]
                                  [langIso639Code],
                            ),
                            ApplicationTextField(
                              bottomPadding: 20,
                              controller: firstNameController,
                              maxLength: 20,
                            ),
                            Text(
                              SystemLang.LANG_MAP[SystemText.LAST_NAME]
                                  [langIso639Code],
                            ),
                            ApplicationTextField(
                              controller: lastNameController,
                              maxLength: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              SystemLang.LANG_MAP[SystemText.EMAIL]
                                  [langIso639Code],
                            ),
                            ApplicationTextField(
                              bottomPadding: 20,
                              controller: emailController,
                              maxLength: 40,
                            ),
                            Text(
                              SystemLang.LANG_MAP[SystemText.PHONE_NUMBER]
                                  [langIso639Code],
                            ),
                            PhoneNumberField(
                              selectedPhoneIsoCode: selectedPhoneIsoCode,
                              controller: phoneController,
                              countryCodeCallback: (value) {
                                selectedPhoneIsoCode = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  child: ApplicationContainerButton(
                    disabled: _isLoading,
                    label: SystemLang.LANG_MAP[SystemText.NEXT]
                        [langIso639Code],
                    loadingOnDisabled: true,
                    color: themeColors[ThemeColor.blue],
                    disabledColor: themeColors[ThemeColor.blue],
                    onPress: () async {
                      if (validateFields(context)) {
                        await saveInfoAsync();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            child: RegistrationTabNavigator(
              selectedColor: themeColors[ThemeColor.blue],
              inactiveColor: themeColors[ThemeColor.hollowGrey],
              currentIndex: 2,
              length: registrationStepCount,
            ),
          ),
        ],
      ),
    );
  }

  void saveInfoAsync() async {
    setState(() {
      _isLoading = true;
    });
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;
    final contact = BusinessContactModel(
      businessId: businessId,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
      phoneIso: selectedPhoneIsoCode,
      email: emailController.text,
    );
    try {
      await widget.dataSource
          .updateBusinessContactAsync(businessId: businessId, contact: contact);
      Provider.of<BusinessProvider>(context, listen: false).update(
          business: Provider.of<BusinessProvider>(context, listen: false)
              .business
              .copyWith(contact: contact));
      widget.registrationUtil.pushRegistrationPageByBusiness(context,
          Provider.of<BusinessProvider>(context, listen: false).business);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
