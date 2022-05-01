/* import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/pages/calendar/theme_calendar.dart';
import 'package:allbert_cms/presentation/pages/calendar/widgets/widget_calendar_create_appointment_sheet.dart';
import 'package:allbert_cms/presentation/pages/calendar/widgets/widget_calendar_create_workblock_sheet.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class CalendarSheet extends StatefulWidget {
  CalendarSheet(
      {Key key,
      @required this.onCreateAppointment,
      @required this.onCreateWorkblock,
      @required this.onClose})
      : super(key: key);

  final OnCreateAppointment onCreateAppointment;
  final OnCreateWorkblock onCreateWorkblock;
  final VoidCallback onClose;

  @override
  _CalendarSheetState createState() => _CalendarSheetState();
}

class _CalendarSheetState extends State<CalendarSheet>
    with TickerProviderStateMixin {
  AnimationController _createAppointmentController;
  Animation _createAppointmentAnimation;

  AnimationController _createWorkBlockController;
  Animation _createWorkBlockAnimation;

  @override
  void initState() {
    super.initState();

    _createAppointmentController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 270),
    );
    _createAppointmentAnimation = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_createAppointmentController);

    _createWorkBlockController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 270),
    );
    _createWorkBlockAnimation = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_createWorkBlockController);
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      width: calendarSheetWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: defaultShadowBlurRadius,
            spreadRadius: defaultShadowSpreadRadius,
            color: lightGrey.withAlpha(defaultShadowAlpha),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: defaultPadding,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  child: Row(
                    children: [
                      Text(
                        SystemLang.LANG_MAP[SystemText.CREATE_APT]
                            [langIso639Code],
                        style: headerStyle_3_bold,
                        textAlign: TextAlign.start,
                      ),
                      Spacer(),
                      Icon(Ionicons.ios_arrow_dropright),
                    ],
                  ),
                  onTap: () {
                    _createAppointmentController.forward();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Row(
                    children: [
                      Text(
                        SystemLang.LANG_MAP[SystemText.CREATE_WORKBLOCK]
                            [langIso639Code],
                        style: headerStyle_3_bold,
                        textAlign: TextAlign.start,
                      ),
                      Spacer(),
                      Icon(Ionicons.ios_arrow_dropright),
                    ],
                  ),
                  onTap: () {
                    _createWorkBlockController.forward();
                  },
                ),
                Spacer(),
                ApplicationContainerButton(
                  label: SystemLang.LANG_MAP[SystemText.CLOSE][langIso639Code],
                  color: themeColors[ThemeColor.pinkRed],
                  onPress: () {
                    widget.onClose();
                  },
                ),
              ],
            ),
            AnimatedBuilder(
              animation: _createAppointmentController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      _createAppointmentAnimation.value * calendarSheetWidth,
                      0),
                  child: child,
                );
              },
              child: AppointmentCreateSheet(
                onBack: () {
                  _createAppointmentController.reverse();
                },
                onClose: () {
                  _createAppointmentController.reverse();
                  widget.onClose();
                },
                onCreateAppointment: (value) {
                  _createAppointmentController.reverse();
                  widget.onCreateAppointment(value);
                },
              ),
            ),
            AnimatedBuilder(
              animation: _createWorkBlockController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      _createWorkBlockAnimation.value * calendarSheetWidth, 0),
                  child: child,
                );
              },
              child: CreateWorkBlockSheet(
                onBack: () {
                  _createWorkBlockController.reverse();
                },
                onClose: () {
                  _createWorkBlockController.reverse();
                  widget.onClose();
                },
                onCreateWorkblock: (value) {
                  _createWorkBlockController.reverse();
                  widget.onCreateWorkblock(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */