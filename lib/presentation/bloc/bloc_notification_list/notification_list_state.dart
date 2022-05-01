part of 'notification_list_bloc.dart';

abstract class NotificationListState extends Equatable {
  const NotificationListState();

  @override
  List<Object> get props => [];
}

class NotificationListInitial extends NotificationListState {}

class NotificationListLoaded extends NotificationListState {
  PagedList<Notification> items;

  NotificationListLoaded(this.items);
}

class NotificationListError extends NotificationListState {
  final Failure failure;

  NotificationListError(this.failure);
}

class NotificationListLoading extends NotificationListState {}
