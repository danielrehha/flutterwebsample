import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_country_name_resolver.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_business_address.dart';
import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/util_registration.dart';
import 'package:allbert_cms/presentation/pages/auth/settings_auth.dart';
import 'package:allbert_cms/presentation/popups/popup_select_city.dart';
import 'package:allbert_cms/presentation/popups/popup_select_country.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widget_registration_tabs_navigator.dart';

class RegistrationAddressTab extends StatefulWidget {
  RegistrationAddressTab({Key key}) : super(key: key);

  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();
  final CountryNameResolver countryNameResolver = CountryNameResolver();
  final RegistrationUtil registrationUtil = RegistrationUtil();

  @override
  _RegistrationAddressTabState createState() => _RegistrationAddressTabState();
}

class _RegistrationAddressTabState extends State<RegistrationAddressTab> {
  TextEditingController countryController = TextEditingController();

  TextEditingController countyController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  Country selectedCountry;

  String contactAlpha2Code;

  String selectedCity;

  TextEditingController zipController = TextEditingController();

  TextEditingController streetNameController = TextEditingController();

  TextEditingController streetTypeController = TextEditingController();

  TextEditingController streetNumberController = TextEditingController();

  TextEditingController addressDescriptionController = TextEditingController();

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  bool validateFields(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    bool error = false;
    String fieldName = "Field";
    if (countryController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.COUNTRY][langIso639Code];
    }
    if (cityController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.CITY][langIso639Code];
    }
    if (zipController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.ZIPCODE][langIso639Code];
    }
    if (streetNameController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.STREET_NAME][langIso639Code];
    }
    if (streetTypeController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.STREET_TYPE][langIso639Code];
    }
    if (streetNumberController.text.isEmpty) {
      error = true;
      fieldName = SystemLang.LANG_MAP[SystemText.STREET_NUMBER][langIso639Code];
    }
    if (error) {
      widget.snackBarActions.dispatchErrorSnackBar(context,
          message:
              "$fieldName ${SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code]}");
    }
    return !error;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Row(
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      SystemLang.LANG_MAP[SystemText.ADDRESS][langIso639Code],
                      style: headerStyle_1_bold,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      SystemLang.LANG_MAP[SystemText.ADDRESS_HINT]
                          [langIso639Code],
                      style: bodyStyle_2_grey,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: defaultColumnWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            SystemLang.LANG_MAP[SystemText.COUNTRY]
                                [langIso639Code],
                          ),
                          ApplicationTextField(
                            bottomPadding: 20,
                            controller: countryController,
                            textAlign: TextAlign.start,
                            readOnly: true,
                            hintText: SystemLang.LANG_MAP[SystemText.SELECT]
                                [langIso639Code],
                            actionChild: InkWell(
                              child: Icon(Icons.arrow_drop_down),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SelectCountryPopup(
                                          selectCountryCallback: (value) {
                                        setState(() {
                                          selectedCountry = value;
                                          countryController.text = widget
                                              .countryNameResolver
                                              .getCountryName(value);
                                        });
                                      });
                                    });
                              },
                            ),
                          ),
                          Text(
                            SystemLang.LANG_MAP[SystemText.CITY]
                                [langIso639Code],
                          ),
                          ApplicationTextField(
                            bottomPadding: 20,
                            controller: cityController,
                            textAlign: TextAlign.start,
                            hintText: selectedCountry == null
                                ? SystemLang.LANG_MAP[SystemText.SELECT]
                                    [langIso639Code]
                                : SystemLang.LANG_MAP[SystemText.SELECT]
                                    [langIso639Code],
                            readOnly: true,
                            actionChild: InkWell(
                              child: Icon(Icons.arrow_drop_down),
                              onTap: () {
                                if (selectedCountry != null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SelectCityPopup(
                                          countryCode:
                                              selectedCountry.alpha2Code,
                                          selectCityCallback: (value) {
                                            setState(() {
                                              selectedCity = value;
                                              cityController.text = value;
                                            });
                                          },
                                        );
                                      });
                                }
                              },
                            ),
                          ),
                          Text(SystemLang.LANG_MAP[SystemText.ZIPCODE]
                              [langIso639Code]),
                          ApplicationTextField(
                            bottomPadding: 20,
                            controller: zipController,
                            textAlign: TextAlign.start,
                            filters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                          Text(SystemLang.LANG_MAP[SystemText.STREET_NAME]
                              [langIso639Code]),
                          ApplicationTextField(
                            bottomPadding: 20,
                            controller: streetNameController,
                            textAlign: TextAlign.start,
                          ),
                          Text(SystemLang.LANG_MAP[SystemText.STREET_TYPE]
                              [langIso639Code]),
                          ApplicationTextField(
                            bottomPadding: 20,
                            controller: streetTypeController,
                            textAlign: TextAlign.start,
                          ),
                          Text(SystemLang.LANG_MAP[SystemText.STREET_NUMBER]
                              [langIso639Code]),
                          ApplicationTextField(
                            bottomPadding: 20,
                            controller: streetNumberController,
                            textAlign: TextAlign.start,
                            filters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                          Text(SystemLang
                                  .LANG_MAP[SystemText.ADDRESS_DESCRIPTION]
                              [langIso639Code]),
                          Text(
                            SystemLang.LANG_MAP[SystemText
                                .ADDRESS_DESCRIPTION_HINT][langIso639Code],
                            style: bodyStyle_2_grey,
                          ),
                          ApplicationTextField(
                            controller: addressDescriptionController,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 40,
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
                                  await saveAddressAsync();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 100,
              child: RegistrationTabNavigator(
                selectedColor: themeColors[ThemeColor.blue],
                inactiveColor: themeColors[ThemeColor.hollowGrey],
                currentIndex: 1,
                length: registrationStepCount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveAddressAsync() async {
    setState(() {
      _isLoading = true;
    });
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;
    final address = BusinessAddressModel(
        businessId: businessId,
        countryName: selectedCountry.name,
        countryNativeName: selectedCountry.nativeName ?? null,
        countryAlpha2Code: selectedCountry.alpha2Code,
        cityName: selectedCity,
        zipCode: zipController.text,
        streetName: streetNameController.text,
        streetType: streetTypeController.text,
        streetNumber: streetNumberController.text,
        description: addressDescriptionController.text);
    try {
      await widget.dataSource
          .updateBusinessAddressAsync(businessId: businessId, address: address);
      Provider.of<BusinessProvider>(context, listen: false).update(
          business: Provider.of<BusinessProvider>(context, listen: false)
              .business
              .copyWith(address: address));
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
