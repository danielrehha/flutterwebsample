import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_size.dart';
import '../main_page_enums.dart';

typedef OnPageSelectCallback = Function(MainPageType page);

// ignore: must_be_immutable
class SideBar extends StatefulWidget {
  final OnPageSelectCallback selectedPageCallback;
  MainPageType currentpage;

  SideBar({Key key, this.selectedPageCallback, this.currentpage})
      : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  void selectPage(MainPageType page) {
    widget.selectedPageCallback(page);
  }

  final SizedBox verticalSpacer = SizedBox(
    height: 12,
  );

  bool isProfileExpanded;

  double iconSpacing = defaultPadding.vertical / 2;

  Color selectedColor = themeColors[ThemeColor.lightBlue];

  @override
  void initState() {
    super.initState();
    isProfileExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding.horizontal / 2,
          vertical: defaultPadding.vertical / 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_CALENDAR]
                  [langIso639Code],
              MainPageType.Calendar,
              Feather.calendar,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_APPOINTMENTS]
                  [langIso639Code],
              MainPageType.Appointments,
              Ionicons.md_time,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_CUSTOMERS]
                  [langIso639Code],
              MainPageType.Customers,
              Ionicons.md_people,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_DASHBOARD]
                  [langIso639Code],
              MainPageType.DashBoard,
              Feather.bar_chart,
            ),
            verticalSpacer,
            /* buildMenuItem(
              "Értesítések",
              MainPageType.Notifications,
              Feather.bell,
              suffixWidget: ApplicationActivityIndicator(activityCount: 2),
            ),
            verticalSpacer, */
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_EMPLOYEES]
                  [langIso639Code],
              MainPageType.Employees,
              SimpleLineIcons.people,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SERVICES]
                  [langIso639Code],
              MainPageType.Services,
              SimpleLineIcons.puzzle,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SCHEDULER]
                  [langIso639Code],
              MainPageType.ScheduleEditor,
              SimpleLineIcons.calendar,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_BILLING]
                  [langIso639Code],
              MainPageType.Billing,
              SimpleLineIcons.credit_card,
            ),
            verticalSpacer,
            /* Container(
              width: 120,
              child: ExpansionPanelList(
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (_, value) {
                  setState(() {
                    isProfileExpanded = !isProfileExpanded;
                  });
                },
                elevation: 0,
                children: [
                  ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: isProfileExpanded,
                    headerBuilder: (context, isOpen) {
                      return Text(
                        SystemLang
                                .LANG_MAP[SystemText.SIDEBAR_ITEM_CUSTOMIZATION]
                            [settings.langIso639Code],
                      );
                    },
                    body: Column(
                      children: [
                        Text(SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_INFO]
                            [settings.langIso639Code]),
                        Text(
                            SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_ADDRESS]
                                [settings.langIso639Code]),
                        Text(
                            SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_RATINGS]
                                [settings.langIso639Code]),
                      ],
                    ),
                  ),
                ],
              ),
            ), */
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_PROFILE]
                  [langIso639Code],
              MainPageType.Profile,
              SimpleLineIcons.wrench,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SETTINGS]
                  [langIso639Code],
              MainPageType.Settings,
              SimpleLineIcons.settings,
            ),
            verticalSpacer,
            buildMenuItem(
              SystemLang.LANG_MAP[SystemText.STATISTICS][langIso639Code],
              MainPageType.Statistics,
              SimpleLineIcons.puzzle,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(String text, MainPageType page, IconData icon,
      {Widget suffixWidget = const SizedBox()}) {
    return InkWell(
      child: Row(
        children: [
          Text(
            text,
            style: getTextStyle(page),
          ),
/*           suffixWidget is SizedBox
              ? SizedBox()
              : SizedBox(
                  width: 4,
                ),
          suffixWidget, */
        ],
      ),
      onTap: () {
        selectPage(page);
      },
    );
  }

  TextStyle getTextStyle(MainPageType page) {
    if (widget.currentpage == page) {
      return TextStyle(
        //color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
    }
    return TextStyle(
      //color: Colors.white,
      fontWeight: FontWeight.w400,
    );
  }
}
