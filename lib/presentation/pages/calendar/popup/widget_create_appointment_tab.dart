import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_phone_dialcode_parser.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_customer.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/popups/popup_select_customer.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:uuid/uuid.dart';

typedef OnCreateAppointment = Function(Appointment);

class CreateAppointmentTab extends StatefulWidget {
  CreateAppointmentTab({
    Key key,
    @required this.initialDate,
    @required this.onCreateAppointment,
  }) : super(key: key);

  final DateTime initialDate;
  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();
  final PersonNameResolver nameResolver = PersonNameResolver();
  final PhoneDialcodeParser dialcodeParser = PhoneDialcodeParser();
  final OnCreateAppointment onCreateAppointment;

  final IApiDataSource dataSource = ApiDataSource();

  @override
  _CreateAppointmentTabState createState() => _CreateAppointmentTabState();
}

class _CreateAppointmentTabState extends State<CreateAppointmentTab> {
  bool _servicesLoading;
  bool _isCreating;

  DateTime _selectedStartDate;
  TimeOfDay _selectedStartTime;

  List<Employee> _employees;
  List<Service> _services;

  Employee _selectedEmployee;
  Service _selectedService;
  Customer _selectedCustomer;

  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _servicesLoading = false;
    _isCreating = false;

    _selectedStartDate = widget.initialDate;
    _selectedStartTime = TimeOfDay.fromDateTime(_selectedStartDate);
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Dialog(
      child: Container(
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
                        SystemLang.LANG_MAP[SystemText.TIMEOFDAY]
                            [langIso639Code],
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
              label: SystemLang.LANG_MAP[SystemText.CLOSE][langIso639Code],
              color: themeColors[ThemeColor.yellowAmber],
              onPress: () {
                if (!_isCreating) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool canCreate(BuildContext context) {
    if (!_isCreating &&
        !_servicesLoading &&
        _selectedCustomer != null &&
        _selectedEmployee != null &&
        _selectedService != null &&
        isStartTimeValid()) {
      return true;
    }
    return false;
  }

  void createAppointmentAsync(BuildContext context) async {
    setState(() {
      _isCreating = true;
    });
    final appointment = AppointmentModel(
      id: Uuid().v4(),
      startDate: _selectedStartDate,
      endDate:
          _selectedStartDate.add(Duration(minutes: _selectedService.duration)),
      status: 0,
      employeeId: _selectedEmployee.id,
      customerId: _selectedCustomer.id,
      serviceId: _selectedService.id,
      service: _selectedService,
      customer: _selectedCustomer,
      employee: _selectedEmployee,
    );
    try {
      await widget.dataSource.createAppointmentAsync(appointment: appointment);
      widget.onCreateAppointment(appointment);
      BlocProvider.of<AppointmentListBloc>(context, listen: false)
          .add(ResetAppointmentListEvent());
      // widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }
    setState(() {
      _isCreating = false;
    });
  }

  double toDuration(TimeOfDay t) => t.hour + t.minute / 60.0;

  bool isStartTimeValid() {
    final selectedTime = TimeOfDay.fromDateTime(_selectedStartDate);
    final now = DateTime.now();
    final nowTime = TimeOfDay.fromDateTime(now);
    if (_selectedStartDate != null && selectedTime != null) {
      if ((_selectedStartDate.year == now.year &&
              _selectedStartDate.month == now.month &&
              _selectedStartDate.day == now.day &&
              toDuration(nowTime) >= toDuration(selectedTime)) ||
          now.isAfter(_selectedStartDate)) {
        return false;
      }
    }

    return true;
  }

  Border getStartTimePickerBorderColor() {
    return isStartTimeValid() ? null : Border.all(color: Colors.red);
  }

  Widget startTimePicker(BuildContext context) {
    final time = TimeOfDay.fromDateTime(_selectedStartDate);
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
          _selectedStartTime = result;
        },
      ),
    );
  }

  Widget startDatePicker(BuildContext context) {
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
            _selectedStartDate == null
                ? "----"
                : widget.translateDate(date: _selectedStartDate),
            style: _selectedStartDate == null ? bodyStyle_2_grey : bodyStyle_2,
          ),
        ),
        onTap: () async {
          final result = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)),
          );
          _selectedStartDate = result;
        },
      ),
    );
  }

  Future<List<Service>> loadServicesAsync() async {
    setState(() {
      _servicesLoading = true;
    });
    final employeeId = _selectedEmployee.id;
    List<Service> result = [];
    try {
      _services = await widget.dataSource
          .getEmployeeServiceListAsync(employeeId: employeeId);
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }
    setState(() {
      _servicesLoading = false;
    });
    return result;
  }

  Widget employeePicker(BuildContext context) {
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
              _selectedEmployee = value;
            },
            value: _selectedEmployee,
            items: _employees.map((e) {
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
              child: getServicePickerChild(context, _services),
            )),
        getServicePickerWarningText(_services),
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
        _selectedService = value;
      },
      value: _selectedService,
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
                  _selectedCustomer == null
                      ? SystemLang.LANG_MAP[SystemText.SELECT_CUSTOMER]
                          [langIso639Code]
                      : "${widget.nameResolver.cultureBasedResolve(
                          firstName: _selectedCustomer.info.firstName,
                          lastName: _selectedCustomer.info.lastName,
                        )} (${widget.dialcodeParser.international(phoneNumber: _selectedCustomer.info.phone, isoCode: _selectedCustomer.info.phoneIso)})",
                  style: _selectedCustomer == null
                      ? bodyStyle_2_grey
                      : bodyStyle_2,
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return SelectCustomerPopup(
                onSelectCustomer: (value) {
                  if (value != null) {
                    _selectedCustomer = value;
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
