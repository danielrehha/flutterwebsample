import 'package:allbert_cms/data/contracts/i_datasource_auth.dart';
import 'package:allbert_cms/data/contracts/i_datasource_local.dart';
import 'package:allbert_cms/data/implementations/datasource_auth.dart';
import 'package:allbert_cms/data/implementations/datasource_local.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserStateHandlerPage extends StatefulWidget {
  UserStateHandlerPage({Key key}) : super(key: key);

  final IAuthSource authSource = FirebaseAuthSource();

  @override
  _UserStateHandlerPageState createState() => _UserStateHandlerPageState();
}

class _UserStateHandlerPageState extends State<UserStateHandlerPage> {
  User user;

  String _errorMessage;

  @override
  void initState() {
    super.initState();

    _errorMessage = "";
  }

  void routerPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/auth/router');
    });
  }

  void verifyPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/auth/verify');
    });
  }

  void loginPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/auth/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _errorMessage.isEmpty
          ? FutureBuilder(
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done) {
                  if (data.data != null) {
                    final user = data.data as User;
                    Provider.of<FirebaseUserProvider>(context, listen: false)
                        .set(data.data);
                    if (user.emailVerified) {
                      routerPage(context);
                    } else {
                      loginPage(context);
                    }
                  } else {
                    loginPage(context);
                  }
                }
                if (data.connectionState == ConnectionState.none) {
                  return Text(data.error.toString());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ApplicationLoadingIndicator(),
                  ],
                );
              },
              future: loadFirebaseUserAsync(),
            )
          : Center(
              child: Text(_errorMessage),
            ),
    );
  }

  Future<User> loadFirebaseUserAsync() async {
    try {
      final result = await widget.authSource.getCurrentUser();
      if (result == null) {
        return result;
      }
      if (!result.emailVerified) {
        print("Signed in, not verified, signing out. (${result.email})");
        await widget.authSource.SignOut();
      }
      return result;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
    return null;
  }
}
