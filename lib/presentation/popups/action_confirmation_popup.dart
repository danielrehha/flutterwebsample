import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
/// Opens a popup that will close itself when [func] and/or [asyncOperation] is completed.
/// Either func or async operation is required.
///
/// If [asyncOperation] is not null it is executed, then executes [func] if not null.
/// 
/// If [asyncOperation] is null then it is skipped and only [func] is executed.
///
class ActionConfirmationPopup extends StatefulWidget {
  const ActionConfirmationPopup({
    Key key,
    this.asyncOperation,
    this.func,
    @required this.headerText,
    @required this.descriptionText,
    @required this.continueButtonLabel,
    @required this.cancelButtonLabel,
    this.popPageCount = 1,
  }) : super(key: key);

  final Function func;
  final AsyncCallback asyncOperation;
  final String headerText;
  final String descriptionText;
  final String continueButtonLabel;
  final String cancelButtonLabel;
  final int popPageCount;

  @override
  _ActionConfirmationPopupState createState() =>
      _ActionConfirmationPopupState();
}

class _ActionConfirmationPopupState extends State<ActionConfirmationPopup> {
  bool _isLoading;

  String _errorMessage;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: UnconstrainedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.headerText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.descriptionText,
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.center,
                ),
                _errorMessage == null
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _errorMessage,
                            style: TextStyle(
                                color: themeColors[ThemeColor.pinkRed]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      child: ApplicationContainerButton(
                        label: widget.cancelButtonLabel,
                        color: themeColors[ThemeColor.pinkRed],
                        onPress: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 150,
                      child: ApplicationContainerButton(
                        loadingOnDisabled: true,
                        disabled: _isLoading,
                        disabledColor: themeColors[ThemeColor.blue],
                        label: widget.continueButtonLabel,
                        color: themeColors[ThemeColor.blue],
                        onPress: () async {
                          if (widget.asyncOperation != null) {
                            await executeOperation();
                          } else {
                            widget.func();
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void executeOperation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.asyncOperation();
      if (widget.func != null) {
        widget.func();
      }
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= widget.popPageCount);
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }
}
