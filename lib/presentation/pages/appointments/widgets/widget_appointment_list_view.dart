import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/domain/helpers/appointment_query_parameters.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:allbert_cms/presentation/pages/appointments/widgets/widget_review_popup.dart';
import 'package:allbert_cms/presentation/popups/action_confirmation_popup.dart';
import 'package:allbert_cms/presentation/popups/popup_customer_details.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class AppointmentListView extends StatefulWidget {
  AppointmentListView({
    Key key,
    this.appointment,
  }) : super(
          key: key,
        );

  final Appointment appointment;

  @override
  _AppointmentListViewState createState() => _AppointmentListViewState();
}

class _AppointmentListViewState extends State<AppointmentListView> {
  final TranslateDate translateDate = TranslateDate();

  final TranslateTime translateTime = TranslateTime();

  final PersonNameResolver nameResolver = PersonNameResolver();

  final IBusinessRepository repository =
      BusinessRepository(dataSource: ApiDataSource());
  final ResultFoldHelper foldHelper = ResultFoldHelper();

  final ApiDataSource dataSource = ApiDataSource();
  final SnackBarActions snackBarActions = SnackBarActions();

  bool isEmployeeDeleted = false;
  bool isCustomerDeleted = false;
  bool isServiceDeleted = false;

  @override
  void initState() {
    super.initState();

    if (widget.appointment.employee == null ||
        widget.appointment.employee.info == null) {
      isEmployeeDeleted = true;
    }
    if (widget.appointment.service == null) {
      isServiceDeleted = true;
    }
    if (widget.appointment.customer == null ||
        widget.appointment.customer.info == null) {
      isCustomerDeleted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationWidgetContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 150,
            child: Row(
              children: [
                ApplicationAvatarImage(
                  radius: 8,
                  size: 40,
                  image: getEmployeeAvatar(),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    getEmployeeName(),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 120,
            child: ApplicationTextButton(
              label: getCustomerName(),
              disabled: isCustomerDeleted,
              onPress: () {
                if (!isCustomerDeleted) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomerDetailsPopup(
                            customerId: widget.appointment.customerId);
                      });
                }
              },
            ),
          ),
          Container(
            width: 180,
            child: Text(
              getAppointmentDateAndTime(),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 120,
            child: Text(
              getServiceName(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 120,
            child: Text(
              getServiceCost(),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 120,
            child: Text(
              getStatusText(widget.appointment.status),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          PopupMenuButton(
              icon: Icon(
                Entypo.dots_three_vertical,
              ),
              onSelected: (value) {
                final action = getPopupMenuItemAction(value);
                action();
              },
              itemBuilder: (context) {
                return getPopupMenuItems();
              }),
        ],
      ),
    );
  }

  String getStatusText(int status) {
    if (status == 0) {
      return "Aktív";
    }
    if (status == 1) {
      return "Kiértékelés";
    }
    if (status == 2) {
      return "Teljesített";
    }
    if (status == 3) {
      return "Nem teljesített";
    }
    if (status == 4) {
      return "Törölt (vendég)";
    }
    return "Törölt (üzlet)";
  }

  ApplicationImage getEmployeeAvatar() {
    if (isEmployeeDeleted) {
      return ApplicationImageModel.empty();
    }
    return widget.appointment.employee.avatar ?? ApplicationImageModel.empty();
  }

  String getEmployeeName() {
    if (isEmployeeDeleted) {
      return "Törölt szakember";
    }
    return nameResolver.cultureBasedResolve(
      firstName: widget.appointment.employee.info.firstName,
      lastName: widget.appointment.employee.info.lastName,
    );
  }

  String getServiceName() {
    if (isServiceDeleted) {
      return "Törölt szolgáltatás";
    }
    return widget.appointment.service.name;
  }

  String getServiceCost() {
    if (isServiceDeleted) {
      return "---";
    }
    return widget.appointment.service.cost.toString() +
        " " +
        widget.appointment.service.currency;
  }

  String getCustomerName() {
    if (isCustomerDeleted) {
      return "Törölt felhasználó";
    }
    return nameResolver.cultureBasedResolve(
      firstName: widget.appointment.customer.info.firstName,
      lastName: widget.appointment.customer.info.lastName,
    );
  }

  String getAppointmentDateAndTime() {
    return translateDate.numeric(widget.appointment.startDate) +
        ", " +
        translateTime(time: widget.appointment.startDate) +
        " - " +
        translateTime(time: widget.appointment.endDate);
  }

  List<Widget> getPopupMenuItems() {
    List<PopupMenuItem> items = [
      PopupMenuItem(
        value: PopupMenuItemAction.CustomerDetails,
        child: Text("Vendég adatai"),
      ),
    ];
    if (widget.appointment.status == 1) {
      items.insert(
        0,
        PopupMenuItem(
          value: PopupMenuItemAction.ReviewAppointment,
          child: Text("Foglalás lezárása"),
        ),
      );
    }
    if (widget.appointment.status == 0) {
      items.insert(
        0,
        PopupMenuItem(
          value: PopupMenuItemAction.DeleteAppointment,
          child: Text("Foglalás törlése"),
        ),
      );
    }
    return items;
  }

  void deleteAppointment() async {
    try {
      snackBarActions.dispatchLoadingSnackBar(context);
      await dataSource.updateAppointmentStatusAsync(
          appointmentId: widget.appointment.id,
          status: AppointmentStatus.DeletedByBusiness);
      snackBarActions.dispatchSuccessSnackBar(context);
      final businessId =
          Provider.of<BusinessProvider>(context, listen: false).businessId;
      BlocProvider.of<AppointmentListBloc>(context).add(
        FetchAppointmentListEvent(
          businessId,
          parameters: AppointmentQueryParameters(orderByDescending: true),
        ),
      );
    } on Exception catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
  }

  void closeReview(AppointmentStatus status) async {
    try {
      snackBarActions.dispatchLoadingSnackBar(context);
      await dataSource.updateAppointmentStatusAsync(
          appointmentId: widget.appointment.id, status: status);
      snackBarActions.dispatchSuccessSnackBar(context);
      final businessId =
          Provider.of<BusinessProvider>(context, listen: false).businessId;
      BlocProvider.of<AppointmentListBloc>(context).add(
        FetchAppointmentListEvent(
          businessId,
          parameters: AppointmentQueryParameters(
            orderByDescending: true,
          ),
        ),
      );
    } on Exception catch (e) {
      snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
  }

  Function getPopupMenuItemAction(PopupMenuItemAction action) {
    if (action == PopupMenuItemAction.DeleteAppointment) {
      return () {
        showDialog(
            context: context,
            builder: (context) {
              return ActionConfirmationPopup(
                  func: () {
                    deleteAppointment();
                    Navigator.of(context).pop();
                  },
                  headerText:
                      "Biztos benne, hogy törölni szeretné az alábbi foglalást?",
                  descriptionText:
                      "${getAppointmentDateAndTime()} - ${getServiceName()}");
            });
      };
    }
    if (action == PopupMenuItemAction.ReviewAppointment) {
      return () {
        showDialog(
            context: context,
            builder: (context) {
              return ReviewAppointmentPopup(
                appointmentDescription:
                    getAppointmentDateAndTime() + " " + getServiceName(),
                reviewCallback: closeReview,
              );
            });
      };
    }
    return () {
      showDialog(
          context: context,
          builder: (context) {
            return CustomerDetailsPopup(
              customerId: widget.appointment.customerId ?? null,
            );
          });
    };
  }
}

enum PopupMenuItemAction {
  DeleteAppointment,
  ReviewAppointment,
  CustomerDetails
}
