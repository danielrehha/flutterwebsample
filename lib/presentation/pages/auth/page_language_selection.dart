import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/contracts/i_datasource_local.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_local.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/util_registration.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_loading_swap_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelectionPage extends StatefulWidget {
  LanguageSelectionPage({Key key}) : super(key: key);

  final RegistrationUtil registrationUtil = RegistrationUtil();
  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();
  final ILocalDataSource localDataSource = LocalDataSource();
  final double iconSize = 125;

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  bool _isLoading;

  String _selectedLangIso639Code;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    _selectedLangIso639Code = "en";
  }

  void changeLang(String lang) {
    if (_selectedLangIso639Code != lang) {
      setState(() {
        _selectedLangIso639Code = lang;
      });
    }
  }

  void userStatePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/auth/state/user');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final widthRatio = width / 1920;
    final heightRatio = height / 1080;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0 * widthRatio, vertical: 150 * heightRatio),
        child: Row(
          children: [
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select your language",
                    style: headerStyle_1_bold,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Choose a language of your preference",
                    style: bodyStyle_2_grey,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          width: widget.iconSize,
                          height: widget.iconSize,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.iconSize),
                            border: _selectedLangIso639Code == "hu"
                                ? Border.all(
                                    color: themeColors[ThemeColor.pinkRed],
                                    width: 3)
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(widget.iconSize),
                                clipBehavior: Clip.antiAlias,
                                child: new OverflowBox(
                                  minWidth: 0.0,
                                  minHeight: 0.0,
                                  maxWidth: double.infinity,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://allbert-vector-images.s3.eu-central-1.amazonaws.com/flag_hungary.png",
                                    placeholder: (context, url) =>
                                        ApplicationLoadingIndicator(),
                                    errorWidget: (context, url, error) {
                                      print(error);
                                      return Icon(Icons.error);
                                    },
                                  ),
                                )),
                          ),
                        ),
                        onTap: () {
                          changeLang("hu");
                        },
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      InkWell(
                        child: Container(
                          width: widget.iconSize,
                          height: widget.iconSize,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.iconSize),
                            border: _selectedLangIso639Code == "en"
                                ? Border.all(
                                    color: themeColors[ThemeColor.pinkRed],
                                    width: 3)
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(widget.iconSize),
                                clipBehavior: Clip.antiAlias,
                                child: new OverflowBox(
                                  minWidth: 0.0,
                                  minHeight: 0.0,
                                  maxWidth: double.infinity,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://allbert-vector-images.s3.eu-central-1.amazonaws.com/flag_united-kingdom.png",
                                    placeholder: (context, url) =>
                                        ApplicationLoadingIndicator(),
                                    errorWidget: (context, url, error) {
                                      print(error);
                                      return Icon(Icons.error);
                                    },
                                  ),
                                )),
                          ),
                        ),
                        onTap: () {
                          changeLang("en");
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 200,
                        child: ApplicationContainerButton(
                          color: themeColors[ThemeColor.blue],
                          label: "Continue",
                          disabled: _isLoading,
                          loadingOnDisabled: true,
                          disabledColor: themeColors[ThemeColor.blue],
                          onPress: () async {
                            if (!_isLoading) {
                              await saveLanguageAsync(context);
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 3,
              child: CachedNetworkImage(
                imageUrl:
                    "https://allbert-vector-images.s3.eu-central-1.amazonaws.com/app+illust+1-07.png",
                placeholder: (context, url) => ApplicationLoadingIndicator(),
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                },
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  void saveLanguageAsync(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.localDataSource
          .saveLangIso639CodeAsync(langIso639Code: _selectedLangIso639Code);
      Provider.of<LanguageProvider>(context, listen: false)
          .setLang(langIso639Code: _selectedLangIso639Code);
      userStatePage(context);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }
}
