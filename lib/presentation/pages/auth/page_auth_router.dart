import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/contracts/i_datasource_auth.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_auth.dart';
import 'package:allbert_cms/data/models/model_business.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/util_registration.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AuthRouterPage extends StatefulWidget {
  AuthRouterPage({Key key}) : super(key: key);

  final IApiDataSource dataSource = ApiDataSource();
  final SnackBarActions snackBarActions = SnackBarActions();
  final RegistrationUtil registrationUtil = RegistrationUtil();
  final IAuthSource authSource = FirebaseAuthSource();

  @override
  _AuthRouterPageState createState() => _AuthRouterPageState();
}

class _AuthRouterPageState extends State<AuthRouterPage> {
  User user;

  String _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadBusinessAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _errorMessage == null ? ApplicationLoadingIndicator() : errorBox(),
      ),
    );
  }

  Widget errorBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Uh oh, lost connection!",
          style: headerStyle_3_bold,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          _errorMessage,
          style: bodyStyle_2_grey,
        ),
        SizedBox(
          height: 10,
        ),
        ApplicationTextButton(
          label: "Refresh",
          onPress: () async {
            setState(() {
              _errorMessage = null;
            });
            loadBusinessAsync();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "or",
          style: bodyStyle_2_grey,
        ),
        SizedBox(
          height: 10,
        ),
        ApplicationTextButton(
          label: "Sign in with a different account",
          onPress: () {
            signOutAndNavigateToLogin();
          },
        ),
      ],
    );
  }

  Future<void> loadBusinessAsync() async {
    final firebaseUid =
        Provider.of<FirebaseUserProvider>(context, listen: false).firebaseUid;
    BusinessModel business = null;
    try {
      business = await widget.dataSource
          .getByFirebaseUidAsync(firebaseUid: firebaseUid);
      Provider.of<BusinessProvider>(context, listen: false)
          .update(business: business);
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      return;
    }
    final route = widget.registrationUtil
        .getRegistrationStateTabRoute(business: business);
    widget.registrationUtil.pushRegistrationPage(context, route);
  }

  Future<void> signOutAndNavigateToLogin() async {
    try {
      await widget.authSource.SignOut();
      Navigator.pushReplacementNamed(context, "/auth/login");
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}
