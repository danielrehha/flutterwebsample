import 'package:allbert_cms/domain/entities/entity_notification.dart' as nt;
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_notification_list/notification_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

typedef OnCloseNotification = Function(String);

class NotificationPopup extends StatefulWidget {
  const NotificationPopup(
      {Key key, @required this.notification, @required this.onClose})
      : super(key: key);

  final nt.Notification notification;
  final OnCloseNotification onClose;

  @override
  _NotificationPopupState createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 270),
    );
    _animation = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
    runRoutine();

    BlocProvider.of<AppointmentListBloc>(context)
        .add(ResetAppointmentListEvent());
    BlocProvider.of<CalendarBloc>(context).add(ResetCalendarEvent());
    BlocProvider.of<NotificationListBloc>(context)
        .add(ResetNotificationListEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void runRoutine() async {
    await Future.delayed(Duration(milliseconds: 300));
    _controller.forward();
    await Future.delayed(Duration(seconds: 5));
    await close();
  }

  void close() async {
    if (_controller.status == AnimationStatus.completed) {
      await _controller.reverse();
      widget.onClose(widget.notification.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value * 120),
          child: child,
        );
      },
      child: Container(
        width: 350,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              spreadRadius: 0.6,
              blurRadius: 10,
              color: themeColors[ThemeColor.hollowGrey],
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Ionicons.md_notifications,
                size: 36,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      widget.notification.title,
                      style: headerStyle_3_bold,
                    ),
                  ),
                  Expanded(child: Text(widget.notification.content))
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Spacer(),
              InkWell(
                child: Icon(
                  Ionicons.md_close,
                ),
                onTap: () async {
                  close();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
