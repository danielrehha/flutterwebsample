import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

typedef ChangeInputCallback = void Function(String);
typedef ValidationCallback = void Function(Map<String, dynamic>);

// ignore: must_be_immutable
class ApplicationTextField extends StatefulWidget {
  ApplicationTextField({
    Key key,
    @required this.controller,
    this.error = false,
    this.maxLength = 50,
    this.hintText = '',
    this.textAlign = TextAlign.start,
    this.filters,
    this.isPassword = false,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.actionChild,
    this.onChanged,
    this.showLength = false,
    this.validationCallback,
    this.canBeEmpty = true,
    this.fieldName = "Field",
    this.topPadding = 10,
    this.bottomPadding = 0,
    this.keyboardType = null,
    this.maxLines = 1,
    this.textAlignVertical = TextAlignVertical.center,
    this.expands = false,
    this.width = null,
    this.showShadow = true,
  }) : super(key: key);

  final String id = Uuid().v4();

  final TextEditingController controller;
  final bool error;
  final Icon suffixIcon;
  final Icon prefixIcon;
  final Widget actionChild;
  final ChangeInputCallback onChanged;
  final bool showLength;
  final ValidationCallback validationCallback;
  final bool canBeEmpty;
  final String fieldName;
  final bool showShadow;
  TextAlign textAlign;
  bool isPassword;
  bool readOnly;
  List<FilteringTextInputFormatter> filters;
  int maxLength;
  String hintText;
  final double topPadding;
  final double bottomPadding;
  final TextInputType keyboardType;
  final int maxLines;
  final TextAlignVertical textAlignVertical;
  final bool expands;
  final double width;

  @override
  _ApplicationTextFieldState createState() => _ApplicationTextFieldState();
}

class _ApplicationTextFieldState extends State<ApplicationTextField> {
  Border errorBorder = Border.all(color: Colors.red, width: 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: widget.topPadding, bottom: widget.bottomPadding),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: getError() ? errorBorder : null,
            boxShadow: widget.showShadow ? [inputBoxShadow] : null),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  expands: widget.expands,
                  readOnly: widget.readOnly,
                  textAlign: widget.textAlign,
                  textAlignVertical: widget.textAlignVertical,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintMaxLines: 1,
                    hintText: widget.hintText,
                    counterText: '',
                    suffixIcon: widget.suffixIcon,
                    prefixIcon: widget.prefixIcon,
                  ),
                  maxLength: widget.maxLength,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.filters,
                  obscureText: widget.isPassword,
                  onChanged: (value) {
                    setState(() {});
                    widget.onChanged(value);
                  },
                  maxLines: widget.maxLines,
                ),
              ),
              widget.actionChild != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: widget.actionChild,
                    )
                  : SizedBox(),
              widget.showLength
                  ? Text(
                      "${widget.controller.text.length}/${widget.maxLength}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  bool getError() {
    /* if (!widget.canBeEmpty && widget.controller.text.isEmpty) {
      return true;
    } */
    return false;
  }
}
