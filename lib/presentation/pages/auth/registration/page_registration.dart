import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/contracts/i_datasource_auth.dart';
import 'package:allbert_cms/data/implementations/datasource_auth.dart';
import 'package:allbert_cms/presentation/bloc/firebase_bloc/firebase_bloc.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/shared/progress_circle.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key}) : super(key: key);

  final IAuthSource authSource = FirebaseAuthSource();

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _passwordRepeatController = TextEditingController();

  bool _isLoading;

  String _errorMessage;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _errorMessage = null;
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

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: defaultColumnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          SystemLang.LANG_MAP[SystemText.NEW_ACCOUNT]
                              [langIso639Code],
                          style: headerStyle_1_bold,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          SystemLang.LANG_MAP[SystemText.EMAIL][langIso639Code],
                          style: bodyStyle_2_grey,
                        ),
                        ApplicationTextField(
                          controller: _emailController,
                          bottomPadding: 20,
                        ),
                        Text(
                          SystemLang.LANG_MAP[SystemText.PASSWORD]
                              [langIso639Code],
                          style: bodyStyle_2_grey,
                        ),
                        ApplicationTextField(
                          controller: _passwordController,
                          isPassword: true,
                          bottomPadding: 20,
                        ),
                        Text(
                          SystemLang.LANG_MAP[SystemText.PASSWORD_CONFIRM]
                              [langIso639Code],
                          style: bodyStyle_2_grey,
                        ),
                        ApplicationTextField(
                          controller: _passwordRepeatController,
                          isPassword: true,
                        ),
                        _errorMessage == null
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _errorMessage,
                                    style: TextStyle(
                                      color: themeColors[ThemeColor.pinkRed],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ApplicationContainerButton(
                                label: SystemLang.LANG_MAP[SystemText.LOG_IN]
                                    [langIso639Code],
                                color: themeColors[ThemeColor.orange],
                                onPress: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: ApplicationContainerButton(
                                label: SystemLang
                                        .LANG_MAP[SystemText.CREATE_ACCOUNT]
                                    [langIso639Code],
                                disabled: _isLoading,
                                loadingOnDisabled: true,
                                disabledColor: themeColors[ThemeColor.blue],
                                color: themeColors[ThemeColor.blue],
                                onPress: () async {
                                  if (doesPasswordMatch()) {
                                    await createAccountAsync(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CachedNetworkImage(
                imageUrl:
                    "https://allbert-vector-images.s3.eu-central-1.amazonaws.com/app+illust+1-01.png",
                placeholder: (context, url) => SizedBox(),
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool doesPasswordMatch() {
    if (_passwordController.text == _passwordRepeatController.text) {
      setState(() {
        _errorMessage = null;
      });
      return true;
    }
    setState(() {
      _errorMessage = "Passwords do not match.";
    });
    return false;
  }

  void createAccountAsync(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await widget.authSource.Register(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Provider.of<FirebaseUserProvider>(context, listen: false).set(result);
      if (result.emailVerified) {
        routerPage(context);
      } else {
        verifyEmailPage(context);
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }
}
