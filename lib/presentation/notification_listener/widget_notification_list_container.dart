import 'package:allbert_cms/domain/helpers/notification_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/paginated_list.dart';
import 'package:allbert_cms/presentation/bloc/bloc_notification_list/notification_list_bloc.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:allbert_cms/domain/entities/entity_notification.dart' as nt;
import "package:timeago/timeago.dart" as timeago;

import '../themes/theme_size.dart';

class NotificationListContainer extends StatefulWidget {
  NotificationListContainer(
      {Key key, this.onClosePanel, this.panelWidth, this.canRender})
      : super(key: key);

  final VoidCallback onClosePanel;
  final double panelWidth;
  final bool canRender;

  @override
  _NotificationListContainerState createState() =>
      _NotificationListContainerState();
}

class _NotificationListContainerState extends State<NotificationListContainer> {
  ScrollController _scrollController;

  bool _canScroll;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _canScroll = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.panelWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 0.7,
              color: themeColors[ThemeColor.hollowGrey],
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding.horizontal / 2,
          vertical: defaultPadding.vertical / 3.4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Értesítések",
                  style: headerStyle_2_bold,
                ),
                InkWell(
                  child: Icon(
                    Ionicons.md_close,
                    color: Colors.black,
                  ),
                  onTap: widget.onClosePanel,
                ),
              ],
            ),
            SizedBox(
              height: paddingBelowHeader,
            ),
            widget.canRender
                ? Expanded(
                    child: BlocConsumer<NotificationListBloc,
                        NotificationListState>(
                      listener: (context, state) {
                        if (state is NotificationListLoaded && _canScroll) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 150),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is NotificationListInitial) {
                          final businessId = Provider.of<BusinessProvider>(
                            context,
                            listen: false,
                          ).businessId;
                          BlocProvider.of<NotificationListBloc>(context).add(
                            FetchNotificationListEvent(
                              businessId,
                              parameters: NotificationQueryParameters(),
                            ),
                          );
                        }
                        if (state is NotificationListLoaded) {
                          if (state.items.items.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Nincs értesítése.")],
                            );
                          }
                          return Column(
                            children: [
                              Expanded(
                                  child: buildNotificationList(
                                      context, state.items)),
                              state.items.paginationData.nextPageLink == null
                                  ? SizedBox()
                                  : ApplicationTextButton(
                                      label: "Több betöltése",
                                      onPress: () {
                                        final businessId =
                                            Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                .businessId;
                                        BlocProvider.of<NotificationListBloc>(
                                                context)
                                            .add(
                                          FetchNotificationListEvent(businessId,
                                              url: state.items.paginationData
                                                  .nextPageLink),
                                        );
                                      },
                                    ),
                            ],
                          );
                        }
                        if (state is NotificationListLoading &&
                            BlocProvider.of<NotificationListBloc>(context)
                                    .previousLoadedState !=
                                null) {
                          return Column(
                            children: [
                              Expanded(
                                  child: buildNotificationList(
                                      context,
                                      BlocProvider.of<NotificationListBloc>(
                                              context)
                                          .previousLoadedState
                                          .items)),
                              ApplicationLoadingIndicator(
                                type: IndicatorType.JumpingDots,
                              ),
                            ],
                          );
                        }
                        if (state is NotificationListError) {
                          return Column(
                            children: [
                              ApplicationTextButton(
                                label: "Frissítés",
                                onPress: () {
                                  final businessId =
                                      Provider.of<BusinessProvider>(
                                    context,
                                    listen: false,
                                  ).businessId;
                                  BlocProvider.of<NotificationListBloc>(context)
                                      .add(
                                    FetchNotificationListEvent(
                                      businessId,
                                      parameters: NotificationQueryParameters(),
                                    ),
                                  );
                                },
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    state.failure.errorMessage,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ApplicationLoadingIndicator(),
                          ],
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationList(
      BuildContext context, PagedList<nt.Notification> notificationList) {
    _canScroll = true;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: notificationList.items.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: notificationListItem(notificationList.items[index]),
          );
        },
      ),
    );
  }

  Widget notificationListItem(nt.Notification item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.title,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              Text(
                item.content,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Text(
          timeago.format(
            item.createdOn,
          ),
          style: TextStyle(
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
