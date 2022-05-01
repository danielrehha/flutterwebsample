import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/services/tabs/service_tabs.dart';
import 'package:allbert_cms/presentation/pages/services/tabs/tab_service_details.dart';
import 'package:allbert_cms/presentation/pages/services/tabs/tab_service_settings.dart';
import 'package:allbert_cms/presentation/pages/services/utils_service.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_status_indicator.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceDetailsPage extends StatefulWidget {
  ServiceDetailsPage({Key key, this.service}) : super(key: key);

  final Service service;
  final IApiDataSource dataSource = ApiDataSource();
  final ServiceUtils serviceUtils = ServiceUtils();
  final SnackBarActions snackBarActions = SnackBarActions();

  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  Map<ServiceTab, Widget> _tabs;

  ServiceTab _selectedTab;

  String _serviceName;

  @override
  void initState() {
    super.initState();

    _selectedTab = ServiceTab.Details;
    _serviceName = widget.service.name;

    _tabs = {
      ServiceTab.Details: ServiceDetailsTab(
        service: widget.service,
        onUpdate: (value) {
          setState(() {
            _serviceName = value.name;
          });
        },
      ),
      ServiceTab.Settings: ServiceSettingsTab(service: widget.service),
    };
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1200,
            minWidth: defaultColumnWidth,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ServiceMenuButton(
                        SystemLang.LANG_MAP[SystemText.INFORMATION]
                            [langIso639Code],
                        ServiceTab.Details,
                      ),
                      ServiceMenuButton(
                        SystemLang.LANG_MAP[SystemText.SETTINGS]
                            [langIso639Code],
                        ServiceTab.Settings,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _serviceName,
                                    style: headerStyle_1_regular,
                                  ),
                                  Text(
                                    "${SystemLang.LANG_MAP[SystemText.ADDED_ON][langIso639Code]}: ${widget.translateDate(date: widget.service.createdOn)}, ${widget.translateTime(time: widget.service.createdOn)}",
                                    style: bodyStyle_2_grey,
                                  ),
                                  ApplicationEntityStatusIndicator(
                                    enabled: widget.service.enabled,
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                width: 150,
                                child: ApplicationContainerButton(
                                  label: SystemLang.LANG_MAP[SystemText.CLOSE]
                                      [langIso639Code],
                                  color: themeColors[ThemeColor.pinkRed],
                                  onPress: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _tabs[_selectedTab],
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getCurrentTabText(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    if (_selectedTab == ServiceTab.Details) {
      return SystemLang.LANG_MAP[SystemText.INFORMATION][langIso639Code];
    }
    if (_selectedTab == ServiceTab.Settings) {
      return SystemLang.LANG_MAP[SystemText.SETTINGS][langIso639Code];
    }
    return SystemLang.LANG_MAP[SystemText.SETTINGS][langIso639Code];
  }

  Widget ServiceMenuButton(String label, ServiceTab tab) {
    return InkWell(
      child: Text(
        label,
        style: getMenuButtonStyle(tab),
      ),
      onTap: () {
        if (_selectedTab != tab) {
          setState(() {
            _selectedTab = tab;
          });
        }
      },
    );
  }

  TextStyle getMenuButtonStyle(ServiceTab tab) {
    if (_selectedTab == tab) {
      return TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    }
    return TextStyle();
  }
}
