/* import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_employee_work_block.dart';
import 'package:allbert_cms/domain/entities/entity_employee_work_block.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/providers/provider_appointment_create.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

typedef OnCreateWorkblock = Function(EmployeeWorkBlock);

class CreateWorkBlockSheet extends StatefulWidget {
  CreateWorkBlockSheet(
      {Key key,
      @required this.onCreateWorkblock,
      @required this.onClose,
      @required this.onBack})
      : super(key: key);

  final OnCreateWorkblock onCreateWorkblock;
  final VoidCallback onClose;
  final VoidCallback onBack;

  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();
  final PersonNameResolver nameResolver = PersonNameResolver();
  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _CreateWorkBlockSheetState createState() => _CreateWorkBlockSheetState();
}

class _CreateWorkBlockSheetState extends State<CreateWorkBlockSheet> {
  bool _isCreating;
  String _errorMessage;

  TextEditingController _durationController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _isCreating = false;

    _durationController = TextEditingController();
    _descriptionController = TextEditingController();

    _durationController.text = "30";

    Provider.of<CalendarProvider>(context, listen: false)
        .updateWorkBlockDuration(30);

    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    final provider = Provider.of<CalendarProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            SystemLang.LANG_MAP[SystemText.CREATE_WORKBLOCK][langIso639Code],
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
                        color: themeColors[ThemeColor.pinkRed],
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 4,
          ),
          Text(
            SystemLang.LANG_MAP[SystemText.EMPLOYEE][langIso639Code],
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
            SystemLang.LANG_MAP[SystemText.SERVICE_DURATION][langIso639Code],
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 4,
          ),
          ApplicationTextField(
            onChanged: (value) {
              Provider.of<CalendarProvider>(context, listen: false)
                  .updateWorkBlockDuration(int.parse(value));
            },
            topPadding: 0,
            controller: _durationController,
            actionChild:
                Text(SystemLang.LANG_MAP[SystemText.MINUTES][langIso639Code]),
            filters: [FilteringTextInputFormatter.digitsOnly],
          ),
          provider.workBlockDuration < 15 || provider.workBlockDuration > 120
              ? Column(
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      SystemLang.LANG_MAP[SystemText
                          .CREATE_WORKBLOCK_MINUTES_ERROR][langIso639Code],
                      style: TextStyle(color: themeColors[ThemeColor.pinkRed]),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 4,
          ),
          Text(
            SystemLang.LANG_MAP[SystemText.BUSINESS_DESCRIPTION]
                [langIso639Code],
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            height: 80,
            child: ApplicationTextField(
              hintText:
                  SystemLang.LANG_MAP[SystemText.WORKBLOCK_DESCRIPTION_HINT]
                      [langIso639Code],
              topPadding: 0,
              textAlignVertical: TextAlignVertical.top,
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLength: 70,
              maxLines: null,
              showLength: true,
              canBeEmpty: false,
              expands: true,
            ),
          ),
          Spacer(),
          Text(
            _errorMessage,
            style: TextStyle(
              color: themeColors[ThemeColor.pinkRed],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ApplicationContainerButton(
            disabledColor: _isCreating ? themeColors[ThemeColor.blue] : null,
            label: SystemLang.LANG_MAP[SystemText.CREATE][langIso639Code],
            disabled: !canCreate(context),
            loadingOnDisabled: _isCreating,
            color: themeColors[ThemeColor.blue],
            onPress: () async {
              if (canCreate(context)) {
                await createWorkBlockAsync(context);
              } else {
                setState(() {});
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
    if (provider.workBlockDuration < 15 || provider.workBlockDuration > 120) {
      return false;
    }
    if (!_isCreating &&
        provider.selectedEmployee != null &&
        isStartTimeValid()) {
      _errorMessage = "";
      return true;
    }
    return false;
  }

  Future<void> createWorkBlockAsync(BuildContext context) async {
    setState(() {
      _isCreating = true;
    });

    String _errorMessage = "";

    final provider = Provider.of<CalendarProvider>(context, listen: false);
    final workBlock = EmployeeWorkBlockModel(
      id: Uuid().v4(),
      employeeId: provider.selectedEmployee.id,
      startTime: provider.createAppointmentSelectedDate,
      endTime: provider.createAppointmentSelectedDate
          .add(Duration(minutes: provider.workBlockDuration)),
      description: _descriptionController.text,
    );
    try {
      await widget.dataSource.createWorkBlockAsync(
        employeeId: provider.selectedEmployee.id,
        workBlock: workBlock,
      );
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    if (_errorMessage.isEmpty) {
      widget.onCreateWorkblock(workBlock);
    }

    setState(() {
      _isCreating = false;
    });
  }

  double toDuration(TimeOfDay t) => t.hour + t.minute / 60.0;

  bool isStartTimeValid() {
    final selectedDate =
        Provider.of<CalendarProvider>(context, listen: false)
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
    final selectedDate = Provider.of<CalendarProvider>(context)
        .createAppointmentSelectedDate;
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
    final date = Provider.of<CalendarProvider>(context)
        .createAppointmentSelectedDate;
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
}
 */