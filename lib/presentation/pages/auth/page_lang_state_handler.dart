import 'package:allbert_cms/data/contracts/i_datasource_local.dart';
import 'package:allbert_cms/data/implementations/datasource_local.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageStateHandlerPage extends StatefulWidget {
  LanguageStateHandlerPage({Key key}) : super(key: key);

  final ILocalDataSource localDataSource = LocalDataSource();

  @override
  _LanguageStateHandlerPageState createState() =>
      _LanguageStateHandlerPageState();
}

class _LanguageStateHandlerPageState extends State<LanguageStateHandlerPage> {
  String _errorMessage;

  @override
  void initState() {
    super.initState();

    _errorMessage = "";
  }

  void statePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/auth/state/user');
    });
  }

  void languagePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/auth/language');
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
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLang(langIso639Code: data.data);
                    statePage(context);
                  } else {
                    languagePage(context);
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
              future: loadLangAsync(),
            )
          : Center(
              child: Text(_errorMessage),
            ),
    );
  }

  Future<String> loadLangAsync() async {
    try {
      final result = await widget.localDataSource.loadLangIso639CodeAsync();
      return result;
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      return null;
    }
  }
}
