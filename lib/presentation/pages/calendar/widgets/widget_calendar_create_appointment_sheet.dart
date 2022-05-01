/* import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_phone_dialcode_parser.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/popups/popup_select_customer.dart';
import 'package:allbert_cms/presentation/providers/provider_appointment_create.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:uuid/uuid.dart';

typedef OnCreateAppointment = Function(Appointment);

class AppointmentCreateSheet extends StatefulWidget {
  AppointmentCreateSheet({
    Key key,
    @required this.onClose,
    @required this.onBack,
    @required this.onCreateAppointment,
  }) : super(key: key);

  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();
  final PersonNameResolver nameResolver = PersonNameResolver();
  final PhoneDialcodeParser dialcodeParser = PhoneDialcodeParser();
  final OnCreateAppointment onCreateAppointment;

  final VoidCallback onClose;
  final VoidCallback onBack;
  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _AppointmentCreateSheetState createState() => _AppointmentCreateSheetState();
}

class _AppointmentCreateSheetState extends State<AppointmentCreateSheet> {
  bool _servicesLoading;
  bool _isCreating;

  @override
  void initState() {
    super.initState();
    _servicesLoading = false;
    _isCreating = false;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            SystemLang.LANG_MAP[SystemText.CREATE_APT][langIso639Code],
            style: headerStyle_2_bold,
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      SystemLang.LANG_MAP[SystemText.DATE][langIso639Code],
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    startDatePicker(context),
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      SystemLang.LANG_MAP[SystemText.TIMEOFDAY][langIso639Code],
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    startTimePicker(context),
                  ],
                ),
              ),
            ],
          ),
          isStartTimeValid()
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      SystemLang.LANG_MAP[SystemText.NO_PAST_DATE_ALLOWED]
                          [langIso639Code],
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 4,
          ),
          Text(
            SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_EMPLOYEES]
                [langIso639Code],
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 4,
          ),
          employeePicker(context),
          SizedBox(
            height: 4,
          ),
          Text(
            SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SERVICES]
                [langIso639Code],
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 4,
          ),
          servicePicker(
            context,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_CUSTOMERS]
                [langIso639Code],
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 4,
          ),
          customerPicker(
            context,
          ),
          Spacer(),
          ApplicationContainerButton(
            disabledColor: _isCreating ? themeColors[ThemeColor.blue] : null,
            label: SystemLang.LANG_MAP[SystemText.CREATE][langIso639Code],
            disabled: !canCreate(context),
            loadingOnDisabled: _isCreating,
            color: themeColors[ThemeColor.blue],
            onPress: () async {
              if (canCreate(context)) {
                await createAppointmentAsync(context);
              }
            },
          ),
          SizedBox(
            height: 8,
          ),
          ApplicationContainerButton(
            label: SystemLang.LANG_MAP[SystemText.BACK][langIso639Code],
            color: themeColors[ThemeColor.yellowAmber],
            onPress: () {
              if (!_isCreating) {
                widget.onBack();
              }
            },
          ),
          SizedBox(
            height: 8,
          ),
          ApplicationContainerButton(
            label: SystemLang.LANG_MAP[SystemText.CLOSE][langIso639Code],
            color: themeColors[ThemeColor.pinkRed],
            onPress: () {
              if (!_isCreating) {
                widget.onClose();
              }
            },
          ),
        ],
      ),
    );
  }

  bool canCreate(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context, listen: false);
    if (!_isCreating &&
        !_servicesLoading &&
        provider.selectedCustomer != null &&
        provider.selectedEmployee != null &&
        provider.selectedService != null &&
        isStartTimeValid()) {
      return true;
    }
    return false;
  }

  void createAppointmentAsync(BuildContext context) async {
    final provider = Provider.of<CalendarProvider>(context, listen: false);
    setState(() {
      _isCreating = true;
    });
    final appointment = AppointmentModel(
      id: Uuid().v4(),
      startDate: provider.createAppointmentSelectedDate,
      endDate: provider.createAppointmentSelectedDate
          .add(Duration(minutes: provider.selectedService.duration)),
      status: 0,
      employeeId: provider.selectedEmployee.id,
      customerId: provider.selectedCustomer.id,
      serviceId: provider.selectedService.id,
      service: provider.selectedService,
      customer: provider.selectedCustomer,
      employee: provider.selectedEmployee,
    );
    try {
      await widget.dataSource.createAppointmentAsync(appointment: appointment);
      widget.onCreateAppointment(appointment);
      BlocProvider.of<AppointmentListBloc>(context, listen: false)
          .add(ResetAppointmentListEvent());
      // widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isCreating = false;
    });
  }

  double toDuration(TimeOfDay t) => t.hour + t.minute / 60.0;

  bool isStartTimeValid() {
    final selectedDate = Provider.of<CalendarProvider>(context, listen: false)
        .createAppointmentSelectedDate;
    final selectedTime = TimeOfDay.fromDateTime(selectedDate);
    final now = DateTime.now();
    final nowTime = TimeOfDay.fromDateTime(now);
    if (selectedDate != null && selectedTime != null) {
      if ((selectedDate.year == now.year &&
              selectedDate.month == now.month &&
              selectedDate.day == now.day &&
              toDuration(nowTime) >= toDuration(selectedTime)) ||
          now.isAfter(selectedDate)) {
        return false;
      }
    }

    return true;
  }

  Border getStartTimePickerBorderColor() {
    return isStartTimeValid() ? null : Border.all(color: Colors.red);
  }

  Widget startTimePicker(BuildContext context) {
    final selectedDate =
        Provider.of<CalendarProvider>(context).createAppointmentSelectedDate;
    final time = TimeOfDay.fromDateTime(selectedDate);
    return Container(
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(4),
        border: getStartTimePickerBorderColor(),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            time == null ? "----" : widget.translateTime.fromTime(time: time),
            style: time == null ? bodyStyle_2_grey : bodyStyle_2,
          ),
        ),
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: time ?? TimeOfDay(hour: 10, minute: 0),
          );
          Provider.of<CalendarProvider>(context, listen: false)
              .updateCreateAppointmentSelectedStartTime(result);
        },
      ),
    );
  }

  Widget startDatePicker(BuildContext context) {
    final date =
        Provider.of<CalendarProvider>(context).createAppointmentSelectedDate;
    return Container(
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(4),
        border: getStartTimePickerBorderColor(),
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            date == null ? "----" : widget.translateDate(date: date),
            style: date == null ? bodyStyle_2_grey : bodyStyle_2,
          ),
        ),
        onTap: () async {
          final result = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)),
          );
          Provider.of<CalendarProvider>(context, listen: false)
              .updateCreateAppointmentSelectedDate(result);
        },
      ),
    );
  }

  Future<List<Service>> loadServicesAsync() async {
    setState(() {
      _servicesLoading = true;
    });
    final employeeId = Provider.of<CalendarProvider>(context, listen: false)
        .selectedEmployee
        .id;
    List<Service> result = [];
    try {
      result = await widget.dataSource
          .getEmployeeServiceListAsync(employeeId: employeeId);
      Provider.of<CalendarProvider>(context, listen: false)
          .updateServiceList(result);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _servicesLoading = false;
    });
    return result;
  }

  Widget employeePicker(BuildContext context) {
    final employees =
        Provider.of<CalendarProvider>(context, listen: false).employees;
    return Container(
        decoration: BoxDecoration(
          color: themeColors[ThemeColor.hollowGrey],
          borderRadius: BorderRadius.circular(4),
        ),
        child: SizedBox(
          height: 40,
          child: DropdownButton(
            underline: SizedBox(),
            onChanged: (value) {
              Provider.of<CalendarProvider>(context, listen: false)
                  .selectEmployee(value);
            },
            value: Provider.of<CalendarProvider>(context).selectedEmployee,
            items: employees.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      ApplicationAvatarImage(
                        image: e.avatar,
                        size: 25,
                        //color: e.info.color,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.nameResolver.cultureBasedResolve(
                            firstName: e.info.firstName,
                            lastName: e.info.lastName),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Widget servicePicker(BuildContext context) {
    final services = Provider.of<CalendarProvider>(context).services;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            decoration: BoxDecoration(
              color: themeColors[ThemeColor.hollowGrey],
              borderRadius: BorderRadius.circular(4),
            ),
            child: SizedBox(
              height: 40,
              child: getServicePickerChild(context, services),
            )),
        getServicePickerWarningText(services),
      ],
    );
  }

  Widget getServicePickerWarningText(List<Service> services) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    if (services == null || services.isNotEmpty) {
      return SizedBox();
    }
    return Column(
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.CREATE_APT_NO_SERVICE_ERROR]
              [langIso639Code],
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget getServicePickerChild(BuildContext context, List<Service> services) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    if (services == null) {
      return FutureBuilder(
        builder: (context, data) {
          return Shimmer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    SystemLang.LANG_MAP[SystemText.LOADING_DOTS]
                        [langIso639Code],
                  ),
                ),
              ],
            ),
            direction: ShimmerDirection.fromLeftToRight(),
            color: Colors.grey,
          );
        },
        future: loadServicesAsync(),
      );
    }
    if (services.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              SystemLang.LANG_MAP[SystemText.NO_ADDED_SERVICE][langIso639Code],
              style: bodyStyle_2_grey,
            ),
          ),
        ],
      );
    }
    return DropdownButton(
      underline: SizedBox(),
      onChanged: (value) {
        Provider.of<CalendarProvider>(context, listen: false)
            .selectService(value);
      },
      value: Provider.of<CalendarProvider>(context).selectedService,
      items: services.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  e.name,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget customerPicker(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    final customer = Provider.of<CalendarProvider>(context).selectedCustomer;
    return Container(
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer == null
                      ? SystemLang.LANG_MAP[SystemText.SELECT_CUSTOMER]
                          [langIso639Code]
                      : "${widget.nameResolver.cultureBasedResolve(
                          firstName: customer.info.firstName,
                          lastName: customer.info.lastName,
                        )} (${widget.dialcodeParser.international(phoneNumber: customer.info.phone, isoCode: customer.info.phoneIso)})",
                  style: customer == null ? bodyStyle_2_grey : bodyStyle_2,
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return SelectCustomerPopup(onSelectCustomer: (value) {
                if (value != null) {
                  Provider.of<CalendarProvider>(context, listen: false)
                      .selectCustomer(value);
                }
              });
            },
          );
        },
      ),
    );
  }
}
 */