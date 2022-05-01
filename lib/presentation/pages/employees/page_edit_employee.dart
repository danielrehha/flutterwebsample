import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_phone_number_validator.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/employees/tabs/employee_tabs.dart';
import 'package:allbert_cms/presentation/pages/employees/tabs/tab_employee_info.dart';
import 'package:allbert_cms/presentation/pages/employees/tabs/tab_employee_ratings.dart';
import 'package:allbert_cms/presentation/pages/employees/tabs/tab_employee_settings.dart';
import 'package:allbert_cms/presentation/pages/employees/utils/utils_employees.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_status_indicator.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateEmployeePage extends StatefulWidget {
  UpdateEmployeePage({Key key, @required this.employee}) : super(key: key);

  final IApiDataSource dataSource = ApiDataSource();

  final EmployeeUtils employeeUtils = EmployeeUtils();
  final SnackBarActions snackBarActions = SnackBarActions();
  final Employee employee;
  final PersonNameResolver personNameResolver = PersonNameResolver();
  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();

  @override
  _UpdateEmployeePageState createState() => _UpdateEmployeePageState();
}

class _UpdateEmployeePageState extends State<UpdateEmployeePage> {
  Map<EmployeeTab, Widget> _tabs;

  EmployeeTab _selectedTab;

  String _firstName;
  String _lastName;

  @override
  void initState() {
    super.initState();

    _selectedTab = EmployeeTab.Details;

    _firstName = widget.employee.info.firstName;
    _lastName = widget.employee.info.lastName;

    _tabs = {
      EmployeeTab.Details: EmployeeInfoTab(
        employee: widget.employee,
        onUpdate: (value) {
          setState(() {
            _firstName = value.firstName;
            _lastName = value.lastName;
          });
        },
      ),
      EmployeeTab.Settings: EmployeeSettingsTab(employee: widget.employee),
      EmployeeTab.Ratings: EmployeeRatingsTab(
        employeeId: widget.employee.id,
      ),
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
                      EmployeeMenuButton(
                        SystemLang.LANG_MAP[SystemText.INFORMATION]
                            [langIso639Code],
                        EmployeeTab.Details,
                      ),
                      EmployeeMenuButton(
                        SystemLang.LANG_MAP[SystemText.RATINGS][langIso639Code],
                        EmployeeTab.Ratings,
                      ),
                      EmployeeMenuButton(
                        SystemLang.LANG_MAP[SystemText.SETTINGS]
                            [langIso639Code],
                        EmployeeTab.Settings,
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
                                    widget.personNameResolver
                                        .cultureBasedResolve(
                                            firstName: _firstName,
                                            lastName: _lastName),
                                    style: headerStyle_1_regular,
                                  ),
                                  Text(
                                    "${SystemLang.LANG_MAP[SystemText.ADDED_ON][langIso639Code]}: ${widget.translateDate(date: widget.employee.createdOn)}, ${widget.translateTime(time: widget.employee.createdOn)}",
                                    style: bodyStyle_2_grey,
                                  ),
                                  ApplicationEntityStatusIndicator(
                                    enabled: widget.employee.enabled,
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
    if (_selectedTab == EmployeeTab.Details) {
      return SystemLang.LANG_MAP[SystemText.INFORMATION][langIso639Code];
    }
    if (_selectedTab == EmployeeTab.Ratings) {
      return SystemLang.LANG_MAP[SystemText.RATINGS][langIso639Code];
    }
    if (_selectedTab == EmployeeTab.Settings) {
      return SystemLang.LANG_MAP[SystemText.SETTINGS][langIso639Code];
    }
    return SystemLang.LANG_MAP[SystemText.SETTINGS][langIso639Code];
  }

  Widget EmployeeMenuButton(String label, EmployeeTab tab) {
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

  TextStyle getMenuButtonStyle(EmployeeTab tab) {
    if (_selectedTab == tab) {
      return TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    }
    return TextStyle();
  }
}
