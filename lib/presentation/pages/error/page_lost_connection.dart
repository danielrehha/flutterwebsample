import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef AsyncResultOperation = Function<Future>();
typedef OnAsyncWithResultSuccess = Function(dynamic);

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({
    Key key,
    @required this.errorMessage,
    this.onSuccess,
    this.asyncOperation,
    this.asyncResultOperation,
    this.onAsyncResultSuccess,
  }) : super(key: key);

  final String errorMessage;
  final VoidCallback onSuccess;
  final OnAsyncWithResultSuccess onAsyncResultSuccess;
  final AsyncCallback asyncOperation;
  final AsyncResultOperation asyncResultOperation;

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  bool _loading;
  String _errorMessage;

  @override
  void initState() {
    _errorMessage = widget.errorMessage;
    _loading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
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
                widget.errorMessage,
                style: bodyStyle_2_grey,
              ),
              SizedBox(
                height: 10,
              ),
              ApplicationTextButton(
                onPress: () async {
                  if (widget.asyncOperation != null) {
                    try {
                      await widget.asyncOperation();
                    } on Exception catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                      return;
                    }
                    widget.onSuccess();
                  }
                  if (widget.asyncResultOperation != null) {
                    try {
                      final result = await widget.asyncResultOperation();
                      widget.onAsyncResultSuccess(result);
                    } on Exception catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                      return;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
