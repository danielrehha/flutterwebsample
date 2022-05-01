import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_business_details.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/util_registration.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/widget_registration_tabs_navigator.dart';
import 'package:allbert_cms/presentation/pages/auth/settings_auth.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_swap_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationDetailsTab extends StatefulWidget {
  RegistrationDetailsTab({Key key}) : super(key: key);

  final RegistrationUtil registrationUtil = RegistrationUtil();
  final SnackBarActions snackBarActions = SnackBarActions();
  final ApiDataSource dataSource = ApiDataSource();

  @override
  _RegistrationDetailsTabState createState() => _RegistrationDetailsTabState();
}

class _RegistrationDetailsTabState extends State<RegistrationDetailsTab> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  bool validateFields(BuildContext ctx) {
    final langIso639Code =
        Provider.of<LanguageProvider>(ctx, listen: false).langIso639Code;
    bool showError = false;
    String fieldName = "field";
    if (_typeController.text.isEmpty) {
      showError = true;
      fieldName =
          SystemLang.LANG_MAP[SystemText.BUSINESS_CATEGORY][langIso639Code];
    }
    if (_nameController.text.isEmpty) {
      showError = true;
      fieldName = SystemLang.LANG_MAP[SystemText.BUSINESS_NAME][langIso639Code];
    }
    if (showError) {
      widget.snackBarActions.dispatchErrorSnackBar(ctx,
          message:
              "$fieldName ${SystemLang.LANG_MAP[SystemText.CANNOT_BE_EMPTY][langIso639Code]}");
    }
    return !showError;
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
                  SystemLang.LANG_MAP[SystemText.INTRODUCTION][langIso639Code],
                  style: headerStyle_1_bold,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 1000,
                  child: Text(
                    SystemLang.LANG_MAP[SystemText.INTRODUCTION_HINT]
                        [langIso639Code],
                    style: bodyStyle_2_grey,
                    textAlign: TextAlign.center,
                  ),
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
                        SystemLang.LANG_MAP[SystemText.BUSINESS_NAME]
                            [langIso639Code],
                      ),
                      ApplicationTextField(
                        bottomPadding: 20,
                        textAlign: TextAlign.start,
                        controller: _nameController,
                        maxLength: 40,
                        showLength: true,
                        canBeEmpty: false,
                      ),
                      Text(
                        SystemLang.LANG_MAP[SystemText.BUSINESS_CATEGORY]
                            [langIso639Code],
                      ),
                      ApplicationTextField(
                        bottomPadding: 20,
                        controller: _typeController,
                        textAlign: TextAlign.start,
                        showLength: true,
                        maxLength: 40,
                        hintText: SystemLang
                                .LANG_MAP[SystemText.BUSINESS_CATEGORY_HINT]
                            [langIso639Code],
                        canBeEmpty: false,
                      ),
                      Text(
                        SystemLang.LANG_MAP[SystemText.BUSINESS_DESCRIPTION]
                            [langIso639Code],
                      ),
                      Text(
                        SystemLang
                                .LANG_MAP[SystemText.BUSINESS_DESCRIPTION_HINT]
                            [langIso639Code],
                        style: bodyStyle_2_grey,
                      ),
                      Container(
                        height: 100,
                        child: ApplicationTextField(
                          textAlignVertical: TextAlignVertical.top,
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLength: 120,
                          maxLines: null,
                          showLength: true,
                          canBeEmpty: false,
                          expands: true,
                        ),
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
                              await saveInfoAsync();
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
          Container(
            width: 100,
            child: RegistrationTabNavigator(
              selectedColor: themeColors[ThemeColor.blue],
              inactiveColor: themeColors[ThemeColor.hollowGrey],
              currentIndex: 0,
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
    try {
      final details = BusinessDetailsModel(
        businessId: businessId,
        name: _nameController.text,
        type: _typeController.text,
        description: _descriptionController.text,
      );
      await widget.dataSource.updateBusinessDetailsAsync(
        businessId: businessId,
        details: details,
      );
      final oldBusiness =
          Provider.of<BusinessProvider>(context, listen: false).business;
      Provider.of<BusinessProvider>(context, listen: false)
          .update(business: oldBusiness.copyWith(details: details));
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
