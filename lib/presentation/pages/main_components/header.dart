import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/contracts/i_datasource_auth.dart';
import 'package:allbert_cms/data/implementations/datasource_auth.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_customer_list/customer_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_notification_list/notification_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_schedule/schedule_bloc.dart';
import 'package:allbert_cms/presentation/bloc/business_portfolio/bloc/business_portfolio_bloc.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:allbert_cms/presentation/bloc/firebase_bloc/firebase_bloc.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/providers/provider_application.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_firebase.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/providers/provider_notification.dart';
import 'package:allbert_cms/presentation/providers/provider_payment_method_selector.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/avatar_image.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_size.dart';
import '../main_page_enums.dart';

typedef SelectedPageCallback = Function(MainPageType page);

class MainPageHeader extends StatefulWidget {
  final SelectedPageCallback selectedPageCallback;
  final VoidCallback openNotificationsPanel;
  final double height;
  final SnackBarActions snackBarActions = SnackBarActions();

  final IAuthSource dataSource = FirebaseAuthSource();

  MainPageHeader({
    Key key,
    @required this.selectedPageCallback,
    @required this.openNotificationsPanel,
    this.height = 25,
  }) : super(key: key);

  @override
  State<MainPageHeader> createState() => _MainPageHeaderState();
}

class _MainPageHeaderState extends State<MainPageHeader> {
  void selectPage(MainPageType page) {
    widget.selectedPageCallback(page);
  }

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BusinessProvider>(context);
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 0.2,
            color: themeColors[ThemeColor.hollowGrey].withAlpha(70),
          ),
        ],
        color: Colors.black87,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding.horizontal / 2,
              //vertical: defaultPadding.vertical / 4,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Allbert Business',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  provider.business.details.name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: AvatarImageWidget(
                    image: provider.avatarImage,
                    size: 35,
                    color: 1,
                    isBusiness: true,
                  ),
                  onTap: () {
                    widget.selectedPageCallback(MainPageType.Profile);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "(${provider.business.subscriptionInfo.subscription.name})",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                /* InkWell(
                  child: Icon(
                    Feather.bell,
                    color: Colors.white,
                  ),
                  onTap: openNotificationsPanel,
                ), */
                ApplicationTextButton(
                  label: SystemLang.LANG_MAP[SystemText.LOG_OUT]
                      [langIso639Code],
                  color: Colors.white,
                  onPress: _isLoading
                      ? null
                      : () async {
                          await signOutAsync(context);
                        },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOutAsync(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    bool _error = false;

    Provider.of<ApplicationProvider>(context, listen: false).showCanvas();

    try {
      await widget.dataSource.SignOut();
    } on FirebaseAuthException catch (e) {
      _error = true;
      widget.snackBarActions.dispatchErrorSnackBar(context, message: e.message);
    } on Exception catch (e) {
      _error = true;
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: e.toString());
    }

    Provider.of<ApplicationProvider>(context, listen: false).hideCanvas();

    setState(() {
      _isLoading = false;
    });

    if (!_error) {
      await Navigator.of(context).pushReplacementNamed("/auth/login");
      resetApplication(context);
    }
  }

  void resetApplication(BuildContext context) {
    // Reset blocs
    BlocProvider.of<AppointmentListBloc>(context)
        .add(ResetAppointmentListEvent());
    BlocProvider.of<CustomerListBloc>(context).add(ResetCustomerListEvent());
    BlocProvider.of<NotificationListBloc>(context)
        .add(ResetNotificationListEvent());
    BlocProvider.of<ScheduleBloc>(context).add(ResetScheduleEvent());
    BlocProvider.of<BusinessPortfolioBloc>(context)
        .add(ResetBusinessPortfolioEvent());
    BlocProvider.of<CalendarBloc>(context).add(ResetCalendarEvent());
    BlocProvider.of<EmployeeBloc>(context).add(ResetEmployeeEvent());
    BlocProvider.of<FirebaseBloc>(context).add(ResetFirebaseEvent());
    BlocProvider.of<ServicesBloc>(context).add(ResetServicesEvent());

    // Reset providers
    Provider.of<BusinessProvider>(context, listen: false).reset();
    Provider.of<FirebaseUserProvider>(context, listen: false).reset();
    Provider.of<LanguageProvider>(context, listen: false).reset();
    Provider.of<NotificationProvider>(context, listen: false).reset();
    Provider.of<PaymentMethodSelectorProvider>(context, listen: false).reset();
  }
}
