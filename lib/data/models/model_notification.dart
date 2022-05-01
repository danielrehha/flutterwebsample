import 'package:allbert_cms/domain/entities/entity_notification.dart';
import 'package:meta/meta.dart';

class NotificationModel extends Notification {
  final String id;
  final String title;
  final String content;
  final String navigationRoute;
  final DateTime createdOn;

  NotificationModel({
    @required this.id,
    @required this.title,
    @required this.content,
    @required this.createdOn,
    this.navigationRoute,
  }) : super(
          id: id,
          title: title,
          content: content,
          navigationRoute: navigationRoute,
          createdOn: createdOn,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: "null",
      title: json["title"],
      content: json["content"],
      navigationRoute: json["navigationRoute"],
      createdOn: DateTime.parse(json["createdOn"]),
    );
  }
}
