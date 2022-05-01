import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/pages/business/tabs/tab_business_address.dart';
import 'package:allbert_cms/presentation/pages/business/tabs/tab_business_contact.dart';
import 'package:allbert_cms/presentation/pages/business/tabs/tab_business_images.dart';
import 'package:allbert_cms/presentation/pages/business/tabs/tab_business_details.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';

enum BusinessPageTab {
  Info,
  Address,
  Contact,
  Images,
  //Ratings,
}

class BusinessPage extends StatefulWidget {
  BusinessPage({Key key}) : super(key: key);

  @override
  _BusinessPageState createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  Map<BusinessPageTab, Widget> tabs;

  BusinessPageTab selectedTab;
  final double menuItemSpacing = 20;

  @override
  void initState() {
    super.initState();
    tabs = {
      BusinessPageTab.Info: BusinessInfoTabV2(),
      BusinessPageTab.Address: BusinessAddressTab(),
      BusinessPageTab.Contact: BusinessContactTab(),
      BusinessPageTab.Images: BusinessImagesTab(),
    };
    selectedTab = BusinessPageTab.Info;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return SingleChildScrollView(
      child: Padding(
        padding: defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_PROFILE]
                      [langIso639Code],
                  style: headerStyle_2_bold,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: tabSelectRow(),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: tabs[selectedTab],
            ),
          ],
        ),
      ),
    );
  }

  Widget tabSelectRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        tabButton(
          "Bemutatkozás",
          BusinessPageTab.Info,
        ),
        SizedBox(
          width: menuItemSpacing,
        ),
        tabButton(
          "Cím",
          BusinessPageTab.Address,
        ),
        SizedBox(
          width: menuItemSpacing,
        ),
        tabButton(
          "Kapcsolattartói adatok",
          BusinessPageTab.Contact,
        ),
        SizedBox(
          width: menuItemSpacing,
        ),
        tabButton(
          "Képek",
          BusinessPageTab.Images,
        ),
        /* SizedBox(
          width: menuItemSpacing,
        ),
        tabButton(
          "Értékelések",
          BusinessPageTab.Ratings,
        ), */
      ],
    );
  }

  Widget tabButton(String name, BusinessPageTab tab) {
    return InkWell(
      onTap: () {
        if (selectedTab != tab) {
          setState(() {
            selectedTab = tab;
          });
        }
      },
      child: Text(
        name,
        style: selectedTab == tab
            ? TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )
            : TextStyle(
                fontSize: 16,
              ),
      ),
    );
  }
}
