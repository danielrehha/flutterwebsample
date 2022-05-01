part of 'notification_list_bloc.dart';

abstract class NotificationListEvent extends Equatable {
  const NotificationListEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationListEvent extends NotificationListEvent {
  final String businessId;
  final NotificationQueryParameters parameters;
  final String url;

  FetchNotificationListEvent(this.businessId, {this.parameters, this.url});
}

class ResetNotificationListEvent extends NotificationListEvent {}
