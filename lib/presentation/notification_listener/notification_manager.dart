import 'package:allbert_cms/presentation/notification_listener/widget_notification_popup.dart';
import 'package:allbert_cms/presentation/providers/provider_notification.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPopupManager extends StatefulWidget {
  NotificationPopupManager({Key key}) : super(key: key);

  @override
  _NotificationPopupManagerState createState() =>
      _NotificationPopupManagerState();
}

class _NotificationPopupManagerState extends State<NotificationPopupManager> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    return Container(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: defaultPadding,
          child: provider.currentNotification == null
              ? SizedBox()
              : NotificationPopup(
                  onClose: (notificationId) {
                    provider.removeCurrentNotification();
                  },
                  notification: provider.currentNotification,
                ),
        ),
      ),
    );
  }
}
