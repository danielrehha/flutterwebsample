import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordTab extends StatefulWidget {
  ChangePasswordTab({Key key}) : super(key: key);

  @override
  _ChangePasswordTabState createState() => _ChangePasswordTabState();
}

class _ChangePasswordTabState extends State<ChangePasswordTab> {
  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController newPasswordConfirmationController =
      TextEditingController();

  String errorMessage = "";

  bool oldPasswordError = false;

  bool newPasswordError = false;

  bool newPasswordConfirmationError = false;

  bool lengthError = true;

  bool matchError = true;

  bool loading = false;

  void watchFields(String value) {
    oldPasswordError = false;
    newPasswordError = false;
    newPasswordConfirmationError = false;

    lengthError = false;
    matchError = false;

    if (oldPasswordController.text.length < 1) {
      oldPasswordError = true;
    }
    if (newPasswordController.text.length < 8) {
      lengthError = true;
    }
    if (newPasswordController.text != newPasswordConfirmationController.text &&
        newPasswordController.text.isNotEmpty &&
        newPasswordConfirmationController.text.isNotEmpty) {
      matchError = true;
    }
    setState(() {});
  }

  bool isPasswordValid() {
    return !lengthError ? matchError : lengthError;
  }

  bool noErrors() {
    if (!oldPasswordError &&
        !newPasswordError &&
        !newPasswordConfirmationError &&
        !lengthError &&
        !matchError) {
      return true;
    }
    return false;
  }

  Future<void> updatePasswordAsync(BuildContext context) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Jelsz?? m??dos??t??sa folyamatban..."),
      ),
    );
    setState(() {
      loading = true;
    });

    final auth = FirebaseAuth.instance;

    AuthCredential credential = EmailAuthProvider.credential(
        email: auth.currentUser.email, password: oldPasswordController.text);

    bool authError = false;

    await auth.currentUser
        .reauthenticateWithCredential(credential)
        .catchError((e) {
      authError = true;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      setState(() {
        loading = false;
      });
    });
    if (!authError) {
      await auth.currentUser
          .updatePassword(newPasswordController.text)
          .then((e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sikeres jelsz?? m??dos??t??s"),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          loading = false;
        });
      }).catchError(
        (e) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Sikeres jelsz?? m??dos??t??s"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            loading = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Jelenlegi jelsz??",
          ),
          ApplicationTextField(
            controller: oldPasswordController,
            error: oldPasswordError,
            onChanged: watchFields,
          ),
          SizedBox(height: 10,),
          Text(
            "??j jelsz??",
          ),
          ApplicationTextField(
            controller: newPasswordController,
            error: isPasswordValid(),
            onChanged: watchFields,
          ),
          SizedBox(height: 10,),
          Text(
            "??j jelsz?? m??gegyszer",
          ),
          ApplicationTextField(
            controller: newPasswordConfirmationController,
            error: isPasswordValid(),
            onChanged: watchFields,
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jelszavak egyeznek",
                    style: passwordRuleTextStyle(matchError),
                  ),
                  Text(
                    "Min. 8 karakter",
                    style: passwordRuleTextStyle(lengthError),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Spacer(),
              ApplicationTextButton(
                label: "Jelsz?? megv??ltoztat??sa",
                onPress: () {
                  updatePasswordAsync(context);
                },
                disabled: !noErrors() || loading,
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle passwordRuleTextStyle(bool isError) {
    return isError
        ? TextStyle(color: Colors.red)
        : TextStyle(color: Colors.green);
  }
}
