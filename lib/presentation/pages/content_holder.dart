import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:allbert_cms/presentation/bloc/firebase_bloc/firebase_bloc.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/notification_listener/notification_manager.dart';
import 'package:allbert_cms/presentation/notification_listener/widget_notification_list_container.dart';
import 'package:allbert_cms/presentation/pages/appointments/page_appointments.dart';
import 'package:allbert_cms/presentation/pages/business/page_business.dart';
import 'package:allbert_cms/presentation/pages/schedule_editor/page_schedule_editor.dart';
import 'package:allbert_cms/presentation/pages/services/page_services.dart';
import 'package:allbert_cms/presentation/pages/settings/page_settings.dart';
import 'package:allbert_cms/presentation/pages/billing/page_billing.dart';
import 'package:allbert_cms/presentation/pages/employees/page_employees.dart';
import 'package:allbert_cms/presentation/pages/main_components/header.dart';
import 'package:allbert_cms/presentation/pages/main_components/sidebar.dart';
import 'package:allbert_cms/presentation/pages/statistics/page_statistics.dart';
import 'package:allbert_cms/presentation/providers/provider_application.dart';
import 'package:allbert_cms/presentation/shared/application_loading_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'calendar/page_calendar.dart';
import 'customers/page_customers.dart';
import 'dashboard/page_dashboard.dart';
import 'main_page_enums.dart';

class ContentHolder extends StatefulWidget {
  ContentHolder({Key key}) : super(key: key);

  final double notificationPanelWidth = 400;
  final double headerSize = 54;

  @override
  _ContentHolderState createState() => _ContentHolderState();
}

class _ContentHolderState extends State<ContentHolder>
    with SingleTickerProviderStateMixin {
  Map<MainPageType, Widget> pages = {};

  MainPageType currentPage = MainPageType.Calendar;

  AnimationController _controller;
  Animation _animation;

  bool canRenderNotificationList;

  @override
  void initState() {
    super.initState();
    pages = {
      MainPageType.DashBoard: DashBoardPage(),
      MainPageType.Calendar: CalendarPage(),
      MainPageType.Profile: BusinessPage(),
      MainPageType.Employees: EmployeesPage(),
      MainPageType.Billing: SubscriptionPage(),
      MainPageType.Services: ServicesPage(),
      MainPageType.Settings: SecurityPage(),
      MainPageType.Appointments: AppointmentsPage(),
      MainPageType.ScheduleEditor: ScheduleEditorPage(),
      MainPageType.Customers: CustomersPage(),
      MainPageType.Statistics: StatisticsPage(),
    };

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 270),
    );
    _animation = Tween(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    canRenderNotificationList = false;
  }

  void signOut() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EmployeeBloc>(context).add(ResetEmployeeEvent());
      BlocProvider.of<FirebaseBloc>(context).add(ResetFirebaseEvent());
      BlocProvider.of<ServicesBloc>(context).add(ResetServicesEvent());
      BlocProvider.of<CalendarBloc>(context).add(ResetCalendarEvent());
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/auth/login', (route) => false);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool canRender = width / height > 1.6;
    final appProvider = Provider.of<ApplicationProvider>(context);
    return Scaffold(
      body: BlocConsumer<FirebaseBloc, FirebaseState>(
        listener: (context, state) {
          if (state is FirebaseSignedOutState) {
            signOut();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    MainPageHeader(
                      selectedPageCallback: (MainPageType page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                      openNotificationsPanel: openNotificationPanel,
                      height: widget.headerSize,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SideBar(
                            currentpage: currentPage,
                            selectedPageCallback: (page) {
                              if (page != currentPage) {
                                setState(() {
                                  currentPage = page;
                                });
                              }
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: canRender
                                      ? pages[currentPage]
                                      : Column(
                                          children: [
                                            Text(
                                              "Kérjük méretezze újra bőngészője ablakát!",
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              NotificationPopupManager(),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        _animation.value * widget.notificationPanelWidth, 0),
                    child: child,
                  );
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: NotificationListContainer(
                      canRender: canRenderNotificationList,
                      panelWidth: widget.notificationPanelWidth,
                      onClosePanel: closeNotificationPanel,
                    ),
                  ),
                ),
              ),
              appProvider.canvasLoading
                  ? Container(
                      color: Colors.black54,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ApplicationLoadingCanvas(),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }

  void closeNotificationPanel() {
    _controller.reverse();
    setState(() {
      canRenderNotificationList = false;
    });
  }

  void openNotificationPanel() {
    _controller.forward();
    setState(() {
      canRenderNotificationList = true;
    });
  }

  String getCurrentPageHeaderText(String langIso639Code) {
    switch (currentPage) {
      case MainPageType.DashBoard:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_DASHBOARD]
            [langIso639Code];
      case MainPageType.Calendar:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_CALENDAR]
            [langIso639Code];
      case MainPageType.Billing:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_BILLING]
            [langIso639Code];
      case MainPageType.Employees:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_EMPLOYEES]
            [langIso639Code];
      case MainPageType.Profile:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_PROFILE]
            [langIso639Code];
      case MainPageType.Settings:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SETTINGS]
            [langIso639Code];
      case MainPageType.Services:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SERVICES]
            [langIso639Code];
      case MainPageType.Appointments:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_APPOINTMENTS]
            [langIso639Code];
      case MainPageType.ScheduleEditor:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SCHEDULER]
            [langIso639Code];
      case MainPageType.SignOut:
        return "Kijelentkezés";
      case MainPageType.Customers:
        return SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_CUSTOMERS]
            [langIso639Code];
    }
    return "Hiba a szöveg betöltése közben";
  }
}
