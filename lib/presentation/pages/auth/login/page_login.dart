import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/contracts/i_datasource_auth.dart';
import 'package:allbert_cms/data/implementations/datasource_auth.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final IAuthSource dataSource = FirebaseAuthSource();

  LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double originalWidth = 1920;

  final double originalHeight = 1080;

  bool _isLoading;
  String _message;

  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text = "rehadaniel13@gmail.com";
    _passwordController.text = "qweqweqwe";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final widthRatio = width / originalWidth;
    final heightRatio = height / originalHeight;

    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Positioned(
            right: 140 * widthRatio,
            child: SizedBox(
              height: height,
              width: width,
              child: CachedNetworkImage(
                imageUrl:
                    "https://allbert-vector-images.s3.eu-central-1.amazonaws.com/sprite_login.png",
                placeholder: (context, url) => SizedBox(),
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(
                  flex: 6,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: defaultColumnWidth, minWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        SystemLang.LANG_MAP[SystemText.LOG_IN][langIso639Code],
                        style: headerStyle_1_bold,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        SystemLang.LANG_MAP[SystemText.EMAIL][langIso639Code],
                        style: bodyStyle_2_grey,
                      ),
                      ApplicationTextField(
                        controller: _emailController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        SystemLang.LANG_MAP[SystemText.PASSWORD]
                            [langIso639Code],
                        style: bodyStyle_2_grey,
                      ),
                      ApplicationTextField(
                        isPassword: true,
                        controller: _passwordController,
                      ),
                      _message == null
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _message,
                                  style: TextStyle(
                                    color: themeColors[ThemeColor.pinkRed],
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            SystemLang.LANG_MAP[SystemText.SIGNUP_QUESTION]
                                [langIso639Code],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ApplicationTextButton(
                            label: SystemLang.LANG_MAP[SystemText.SIGNUP]
                                [langIso639Code],
                            color: themeColors[ThemeColor.pinkRed],
                            onPress: () {
                              Navigator.of(context)
                                  .pushNamed("/auth/registration");
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 250,
                            child: ApplicationContainerButton(
                              disabled: _isLoading,
                              loadingOnDisabled: true,
                              disabledColor: themeColors[ThemeColor.blue],
                              label: SystemLang.LANG_MAP[SystemText.LOG_IN]
                                  [langIso639Code],
                              color: themeColors[ThemeColor.blue],
                              onPress: () async {
                                if (canSignIn()) {
                                  await signInAsync();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void signInAsync() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await widget.dataSource.SignIn(
          email: _emailController.text, password: _passwordController.text);
      Provider.of<FirebaseUserProvider>(context, listen: false).set(result);
      if (result.emailVerified) {
        routerPage(context);
      } else {
        verifyEmailPage(context);
      }
    } on FirebaseAuthException catch (e) {
      _message = e.message;
    } on Exception catch (e) {
      _message = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void routerPage(context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.of(context).pushNamed('/auth/router');
      },
    );
  }

  void verifyEmailPage(context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.of(context).pushNamed('/auth/verify');
      },
    );
  }

  bool canSignIn() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
