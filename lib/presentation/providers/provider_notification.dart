import 'package:allbert_cms/data/endpoints/endpoint_naming_context.dart';
import 'package:allbert_cms/domain/entities/entity_notification.dart' as nt;
import 'package:flutter/cupertino.dart';
import 'package:signalr_netcore/signalr_client.dart';

class NotificationProvider extends ChangeNotifier {
  List<nt.Notification> notificationQue = [];

  nt.Notification currentNotification;

  final String notificationHubUri = "$HOST_URI/notifications";

  HubConnection hubConnection;

  void startConnection({@required String businessId}) async {
    final queryString =
        "?entityId=$businessId&entityType=business&sessionType=web";
    final personalizedHubUrl = notificationHubUri + queryString;
    hubConnection = HubConnectionBuilder().withUrl(personalizedHubUrl).build();
    hubConnection.onclose(
      ({error}) {
        print("Hub connection closed: $error");
      },
    );
    hubConnection.on("ReceiveNotification", receiveNotification);
    await hubConnection.start();
  }

  void receiveNotification(List<Object> obj) async {
    final notification = nt.Notification(
      id: obj[0],
      title: obj[1],
      content: obj[2],
      createdOn: DateTime.parse(obj[3].toString()),
    );
    if (currentNotification == null) {
      currentNotification = notification;
    } else {
      //notificationQue.add(notification);
      currentNotification = null;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 20));
      currentNotification = notification;
    }
    notifyListeners();
  }

  void removeCurrentNotification() {
    currentNotification = null;
    notifyListeners();
  }

  void reset() {
    currentNotification = null;
  }
}
