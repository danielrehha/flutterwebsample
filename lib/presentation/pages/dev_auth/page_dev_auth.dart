import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';

class DevAuthPage extends StatefulWidget {
  const DevAuthPage({Key key}) : super(key: key);

  @override
  _DevAuthPageState createState() => _DevAuthPageState();
}

class _DevAuthPageState extends State<DevAuthPage> {
  final TextEditingController sauceController = TextEditingController();

  bool sauceError = false;

  final double itemSpacing = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            child: Column(
              children: [
                Icon(
                  Icons.work,
                  size: 48,
                ),
                SizedBox(
                  height: itemSpacing,
                ),
                Text(
                  'Coming (very) soon!',
                  style: headerStyle_2_bold,
                ),
                SizedBox(
                  height: itemSpacing,
                ),
                Text('Are you a developer? Provide the sauce!'),
                SizedBox(
                  height: itemSpacing,
                ),
                Container(
                  width: 300,
                  child: ApplicationTextField(
                    controller: sauceController,
                    error: sauceError,
                    hintText: 'Secret sauce',
                    isPassword: true,
                  ),
                ),
                SizedBox(
                  height: itemSpacing,
                ),
                ElevatedButton(
                  onPressed: () {
                    validateSauce();
                  },
                  child: Text(
                    'Try sauce',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void validateSauce() {
    if (sauceController.text == 'thisisthesauce') {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/auth/login', (route) => false);
    } else {
      setState(() {
        sauceError = true;
      });
    }
  }
}
