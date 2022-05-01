import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatefulWidget {
  VerifyEmailPage({Key key}) : super(key: key);

  final SnackBarActions snackBarActions = SnackBarActions();

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  String mockEmail = "example@example.com";

  bool _isLoading = false;

  void resendEmailAsync(BuildContext context, User user,
      {@required String successMessage}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await user.sendEmailVerification().catchError((err) {
        widget.snackBarActions
            .dispatchErrorSnackBar(context, err: err.toString());
        setState(() {
          _isLoading = false;
        });
        return;
      });
      widget.snackBarActions
          .dispatchSuccessSnackBar(context, message: successMessage);
    } on FirebaseAuthException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> checkVerificationStateAsync(User user) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await user.reload();
      final auth = FirebaseAuth.instance;
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isLoading = false;
    });
    return user.emailVerified;
  }

  void pushToRouter() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushNamed('/auth/router');
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUserProvider>(context).user;
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Row(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl:
                    "https://allbert-vector-images.s3.eu-central-1.amazonaws.com/app+illust+1-09.png",
                placeholder: (context, url) => SizedBox(),
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                },
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    SystemLang.LANG_MAP[SystemText.CONFIRM_EMAIL]
                        [langIso639Code],
                    style: headerStyle_3_bold,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 500,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: bodyStyle_2_grey,
                        children: <TextSpan>[
                          new TextSpan(
                            text: SystemLang
                                    .LANG_MAP[SystemText.CONFIRM_EMAIL_TEXT_1]
                                [langIso639Code],
                          ),
                          new TextSpan(
                            text: user == null ? "email" : user.email,
                            style: new TextStyle(
                                fontSize: 14,
                                color: themeColors[ThemeColor.pinkRed]),
                          ),
                          new TextSpan(
                            text: SystemLang
                                    .LANG_MAP[SystemText.CONFIRM_EMAIL_TEXT_2]
                                [langIso639Code],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ApplicationTextButton(
                      label: SystemLang.LANG_MAP[SystemText.REFRESH]
                          [langIso639Code],
                      disabled: _isLoading,
                      onPress: () async {
                        if (!_isLoading) {
                          final result =
                              await checkVerificationStateAsync(user);
                          if (result) {
                            Provider.of<FirebaseUserProvider>(context,
                                    listen: false)
                                .set(user);
                            pushToRouter();
                          } else {
                            widget.snackBarActions.dispatchErrorSnackBar(
                              context,
                              message: SystemLang
                                      .LANG_MAP[SystemText.CONFIRM_EMAIL_FAILED]
                                  [langIso639Code],
                            );
                          }
                        }
                      }),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    SystemLang.LANG_MAP[SystemText.CONFIRM_EMAIL_DIDNTRECEIVE]
                        [langIso639Code],
                    style: bodyStyle_2_grey,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ApplicationTextButton(
                    label: SystemLang.LANG_MAP[SystemText.CONFIRM_EMAIL_RESEND]
                        [langIso639Code],
                    disabled: _isLoading,
                    onPress: () {
                      if (!_isLoading) {
                        resendEmailAsync(context, user,
                            successMessage: SystemLang
                                    .LANG_MAP[SystemText.CONFIRM_EMAIL_SENT]
                                [langIso639Code]);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
