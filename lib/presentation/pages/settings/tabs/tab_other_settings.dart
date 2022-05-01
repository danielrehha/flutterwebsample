import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/utils/util_payment_method_utils.dart';
import 'package:allbert_cms/data/contracts/i_datasource_local.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_local.dart';
import 'package:allbert_cms/data/models/model_business_settings.dart';
import 'package:allbert_cms/domain/entities/entity_business_settings.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/settings/widgets/widget_payment_method_selector.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/providers/provider_payment_method_selector.dart';
import 'package:allbert_cms/presentation/shared/application_check_box.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherSettingsTab extends StatefulWidget {
  OtherSettingsTab({Key key}) : super(key: key);

  final ApiDataSource dataSource = ApiDataSource();
  final SnackBarActions snackBarActions = SnackBarActions();
  final ILocalDataSource localDataSource = LocalDataSource();

  @override
  _OtherSettingsTabState createState() => _OtherSettingsTabState();
}

class _OtherSettingsTabState extends State<OtherSettingsTab> {
  bool appointmentEmailsEnabled;
  bool promotionalEmailsEnabled;

  bool sendChangeNotificationEmailToBusiness;

  bool darkModeEnabled;

  double sectionSpacing = 50;

  BusinessSettings _settings;

  String _selectedLangIso639Code;

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _settings =
        Provider.of<BusinessProvider>(context, listen: false).business.settings;

    _isLoading = false;

    final provider =
        Provider.of<PaymentMethodSelectorProvider>(context, listen: false);

    _selectedLangIso639Code = _settings.langIso639Code;
    provider.updateSelectedList(_settings.paymentMethods);
    appointmentEmailsEnabled = _settings.appointmentEmailsEnabled;
    promotionalEmailsEnabled = _settings.promotionalEmailsEnabled;

    darkModeEnabled = _settings.darkModeEnabled;
  }

  void updateSettingsAsync() async {
    setState(() {
      _isLoading = true;
    });

    widget.snackBarActions.dispatchLoadingSnackBar(context);

    bool langError = false;

    try {
      await widget.localDataSource
          .saveLangIso639CodeAsync(langIso639Code: _selectedLangIso639Code);
      Provider.of<LanguageProvider>(context, listen: false)
          .setLang(langIso639Code: _selectedLangIso639Code);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
      langError = true;
    }

    if (!langError) {
      final settings = BusinessSettingsModel(
        businessId: _settings.businessId,
        langIso639Code: _selectedLangIso639Code,
        appointmentEmailsEnabled: appointmentEmailsEnabled,
        promotionalEmailsEnabled: promotionalEmailsEnabled,
        darkModeEnabled: darkModeEnabled,
        paymentMethods: Provider.of<PaymentMethodSelectorProvider>(context,listen: false).selectedPaymentMethods,
      );
      try {
        await widget.dataSource.updateBusinessSettingsAsync(
            businessId: settings.businessId, settings: settings);
        Provider.of<BusinessProvider>(context, listen: false).update(
            business: Provider.of<BusinessProvider>(context, listen: false)
                .business
                .copyWith(settings: settings));

        widget.snackBarActions.dispatchSuccessSnackBar(context);
      } on Exception catch (e) {
        final previousState =
            Provider.of<BusinessProvider>(context, listen: false)
                .business
                .settings;

        _selectedLangIso639Code = previousState.langIso639Code;
        appointmentEmailsEnabled = previousState.appointmentEmailsEnabled;
        promotionalEmailsEnabled = previousState.promotionalEmailsEnabled;
        darkModeEnabled = previousState.darkModeEnabled;

        widget.snackBarActions.dispatchErrorSnackBar(
          context,
          err: (e is ServerException) ? e.message : e.toString(),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [],
      ),
      //width: 600,
      child: Padding(
        padding: defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nyelv",
                      style: headerStyle_3_bold,
                    ),
                    Text(
                      "Kezelőfelület, értesítések, rendszer által küldött e-mailek",
                      style: bodyStyle_2_grey,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: DropdownButton(
                      underline: SizedBox(),
                      value: _selectedLangIso639Code,
                      items: ["hu", "en"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  mapLanguageName(e),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (_selectedLangIso639Code != value && !_isLoading) {
                          setState(() {
                            _selectedLangIso639Code = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sectionSpacing,
            ),
            Text(
              "Email értesítések",
              style: headerStyle_3_bold,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Foglalásokkal kapcsolatos értesítések",
                        ),
                        Row(
                          children: [
                            Text(
                              "A fiók e-mail címre ",
                              style: bodyStyle_2_grey,
                            ),
                            Text(
                              "(rehadaniel.personal@gmail.com)",
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    ApplicationCheckBox(
                      onTap: (value) {
                        if (!_isLoading) {
                          setState(() {
                            appointmentEmailsEnabled = value;
                          });
                        }
                      },
                      value: appointmentEmailsEnabled,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Promóciókkal kapcsolatos értesítések",
                        ),
                        Text(
                          "Az adott alkalmazott e-mail címére",
                          style: bodyStyle_2_grey,
                        ),
                      ],
                    ),
                    Spacer(),
                    ApplicationCheckBox(
                      onTap: (value) {
                        if (!_isLoading) {
                          setState(() {
                            promotionalEmailsEnabled = value;
                          });
                        }
                      },
                      value: promotionalEmailsEnabled,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: sectionSpacing,
            ),
            Text(
              "Fizetési módok",
              style: headerStyle_3_bold,
            ),
            PaymentMethodSelector(),
            SizedBox(
              height: sectionSpacing,
            ),
            Text(
              "Egyéb",
              style: headerStyle_3_bold,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Sötét mód",
                  style: bodyStyle_2_grey,
                ),
                Spacer(),
                ApplicationCheckBox(
                  onTap: (value) {
                    if (darkModeEnabled != value && !_isLoading) {
                      setState(() {
                        darkModeEnabled = value;
                      });
                    }
                  },
                  value: darkModeEnabled,
                ),
              ],
            ),
            SizedBox(
              height: sectionSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ApplicationTextButton(
                  label: "Változtatások mentése",
                  fontWeight: FontWeight.bold,
                  disabled: _isLoading,
                  onPress: () {
                    updateSettingsAsync();
                  },
                  color: Colors.black,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String mapLanguageName(String iso639code) {
    if (iso639code == "hu") {
      return "Magyar";
    }
    return "English";
  }
}
