import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/error/container_error.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:allbert_cms/presentation/themes/theme_text.dart';

enum EmailUpdateStep {
  Initial,
  Awaiting,
  Error,
}

class ChangeEmailTab extends StatefulWidget {
  ChangeEmailTab({Key key}) : super(key: key);

  final SnackBarActions snackBarActions = SnackBarActions();

  @override
  _ChangeEmailTabState createState() => _ChangeEmailTabState();
}

class _ChangeEmailTabState extends State<ChangeEmailTab> {
  final TextEditingController emailController = TextEditingController();

  EmailUpdateStep currentStep = EmailUpdateStep.Initial;

  bool emailError = false;

  String errorMessage = "";

  bool loading = false;

  Map<EmailUpdateStep, Widget> emailStepContainers = {};

  @override
  void initState() {
    super.initState();
    emailStepContainers.addAll(
      {
        EmailUpdateStep.Initial: initialContainer(),
        EmailUpdateStep.Awaiting: awaitingVerificationContainer(),
        EmailUpdateStep.Error: ErrorContainer(
          errorHandlerCallback: () {
            setState(() {
              currentStep = EmailUpdateStep.Initial;
            });
          },
          failure:
              ServerFailure("Hiba történt a művelet során, próbálkozzon újra!"),
        )
      },
    );
  }

  bool isEmailValid(String value) {
    setState(() {
      emailError = false;
    });
    if (value == null || value.isEmpty) {
      setState(() {
        emailError = true;
      });
    }
    if (!EmailValidator.validate(value)) {
      setState(() {
        emailError = true;
      });
    }
    return !emailError;
  }

  Future<void> updateEmailAsync(BuildContext context) async {
    widget.snackBarActions.dispatchLoadingSnackBar(context);

    setState(() {
      loading = true;
    });

    final auth = FirebaseAuth.instance;

    await auth.currentUser
        .verifyBeforeUpdateEmail(emailController.text)
        .then((value) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ellenőrző levél elküldve!"),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        loading = false;
        currentStep = EmailUpdateStep.Awaiting;
      });
    }).catchError((e) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, err: e.toString());
      setState(() {
        loading = false;
        currentStep = EmailUpdateStep.Error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: MediaQuery.of(context).size.height * 0.7,
      child: emailStepContainers[currentStep],
    );
  }

  TextStyle passwordRuleTextStyle(bool isError) {
    return isError
        ? TextStyle(color: Colors.red)
        : TextStyle(color: Colors.green);
  }

  Widget awaitingVerificationContainer() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ellenőrző levelet küldtünk a megadott e-mail címre",
            style: headerStyle_3_bold,
          ),
         SizedBox(height: 10,),
          Text(
              "A levélben található linkre kattintva igazolja vissza e-mail címét, ezt követően új e-mail címe mentésre kerül."),
          SizedBox(height: 10,),
          ApplicationTextButton(
              label: "Kész",
              onPress: () {
                setState(() {
                  currentStep = EmailUpdateStep.Initial;
                });
              })
        ],
      ),
    );
  }

  Widget initialContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Új e-mail cím",
        ),
        ApplicationTextField(
          controller: emailController,
          error: emailError,
          // onChanged: isEmailValid,
        ),
     SizedBox(height: 10,),
        Row(
          children: [
            Spacer(),
            ApplicationTextButton(
              label: "E-mail cím megváltoztatása",
              onPress: () {
                if (isEmailValid(emailController.text)) {
                  updateEmailAsync(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
