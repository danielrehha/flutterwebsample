import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/pages/settings/tabs/tab_change_email.dart';
import 'package:allbert_cms/presentation/pages/settings/tabs/tab_change_password.dart';
import 'package:allbert_cms/presentation/pages/settings/tabs/tab_other_settings.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

enum SettingsTab {
  None,
  ChangePassword,
  ChangeEmail,
  Other,
}

class SecurityPage extends StatefulWidget {
  SecurityPage({Key key}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final Map<SettingsTab, Widget> tabs = {
    SettingsTab.ChangePassword: ChangePasswordTab(),
    SettingsTab.ChangeEmail: ChangeEmailTab(),
    SettingsTab.Other: OtherSettingsTab(),
  };

  SettingsTab selectedTab = SettingsTab.None;

  Map<SettingsTab, String> tabTitles = {
    SettingsTab.ChangePassword: "Jelszó megváltoztatása",
    SettingsTab.ChangeEmail: "E-mail cím megváltoztatása",
    SettingsTab.Other: "Egyéb",
  };

  String getTabTitle(String langIso639Code, SettingsTab tab) {
    switch (tab) {
      case SettingsTab.ChangePassword:
        return SystemLang.LANG_MAP[SystemText.PAGE_SETTINGS_MENU_PASSWORD]
            [langIso639Code];
      case SettingsTab.ChangeEmail:
        return SystemLang.LANG_MAP[SystemText.PAGE_SETTINGS_MENU_EMAIL]
            [langIso639Code];
      case SettingsTab.Other:
        return SystemLang.LANG_MAP[SystemText.PAGE_SETTINGS_MENU_OTHER]
            [langIso639Code];
      case SettingsTab.None:
        return SystemLang.LANG_MAP[SystemText.PAGE_SETTINGS_MENU_EMAIL]
            [langIso639Code];
        break;
      default:
        return "Menu";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<BusinessProvider>(context).business;
    return Padding(
      padding: defaultPadding,
      child: selectedTab == SettingsTab.None
          ? rootContent()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SETTINGS]
                          [settings.settings.langIso639Code],
                      style: headerStyle_2_bold,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Row(
                    children: [
                      Icon(
                        SimpleLineIcons.arrow_left,
                        size: 14,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        getTabTitle(
                            settings.settings.langIso639Code, selectedTab),
                        style: headerStyle_3_bold,
                      ),
                      Spacer(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedTab = SettingsTab.None;
                    });
                  },
                ),
                SizedBox(
                  height: paddingBelowHeader,
                ),
                Spacer(),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 700),
                  child: tabs[selectedTab],
                ),
                Spacer(),
              ],
            ),
    );
  }

  Widget rootContent() {
    final business = Provider.of<BusinessProvider>(context).business;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SETTINGS]
                  [business.settings.langIso639Code],
              style: headerStyle_2_bold,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ApplicationTextButton(
            label: SystemLang.LANG_MAP[SystemText.PAGE_SETTINGS_MENU_EMAIL]
                [business.settings.langIso639Code],
            onPress: () {
              setState(() {
                selectedTab = SettingsTab.ChangeEmail;
              });
            }),
        SizedBox(height: 10,),
        ApplicationTextButton(
            label: SystemLang.LANG_MAP[SystemText.PAGE_SETTINGS_MENU_PASSWORD]
                [business.settings.langIso639Code],
            onPress: () {
              setState(() {
                selectedTab = SettingsTab.ChangePassword;
              });
            }),
        SizedBox(height: 10,),
        ApplicationTextButton(
            label: SystemLang.LANG_MAP[SystemText.PAGE_SETTINGS_MENU_OTHER]
                [business.settings.langIso639Code],
            onPress: () {
              setState(() {
                selectedTab = SettingsTab.Other;
              });
            }),
      ],
    );
  }
}
