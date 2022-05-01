import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/domain/entities/entity_notification.dart';
import 'package:allbert_cms/domain/helpers/notification_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/paginated_list.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  NotificationListBloc({@required this.repository})
      : super(NotificationListInitial());

  final IBusinessRepository repository;
  final ResultFoldHelper foldHelper = ResultFoldHelper();

  NotificationListLoaded previousLoadedState;

  @override
  Stream<NotificationListState> mapEventToState(
    NotificationListEvent event,
  ) async* {
    if (event is FetchNotificationListEvent) {
      yield NotificationListLoading();
      final result = await repository.getBusinessNotificationList(
        businessId: event.businessId,
        parameters: event.parameters,
        url: event.url,
      );
      if (result.isRight()) {
        if (previousLoadedState == null || previousLoadedState.items == null) {
          previousLoadedState = NotificationListLoaded(
            result.getOrElse(() => null),
          );
          yield previousLoadedState;
        } else {
          previousLoadedState.items.items
              .addAll(result.getOrElse(() => null).items);
          previousLoadedState.items.paginationData =
              result.getOrElse(() => null).paginationData;
          yield previousLoadedState;
        }
      } else {
        yield NotificationListError(foldHelper.extract(result));
      }
    }
    if (event is ResetNotificationListEvent) {
      previousLoadedState = null;
      yield NotificationListInitial();
    }
  }
}
