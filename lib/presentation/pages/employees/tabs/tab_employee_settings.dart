import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_employee_schedule_settings.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee_settings.dart';
import 'package:allbert_cms/domain/enums/enum_entity_status.dart';
import 'package:allbert_cms/domain/enums/enum_entity_type.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:allbert_cms/presentation/popups/action_confirmation_popup.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class EmployeeSettingsTab extends StatefulWidget {
  EmployeeSettingsTab({Key key, @required this.employee}) : super(key: key);

  final Employee employee;
  final List<int> bookingFrequencyOptions = [15, 30, 60];
  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _EmployeeSettingsTabState createState() => _EmployeeSettingsTabState();
}

class _EmployeeSettingsTabState extends State<EmployeeSettingsTab> {
  int selectedBookingFrequency = 30;

  int selectedBookingDeletionDeadline = 1;

  int selectedBookingCreationDeadline = 1;

  int selectedAllowedCustomerBookingindex = 1;

  int previousSelectedBookingFrequency;

  int previousSelectedBookingDeletionDeadline;

  int previousSelectedBookingCreationDeadline;

  int previousSelectedAllowedCustomerBookingindex;

  bool _isSaving;

  bool _isLoading;

  String _errorMessage;

  @override
  void initState() {
    super.initState();

    _isSaving = false;
    _isLoading = false;
    _errorMessage = "";

    loadEmployeeSettingsAsync();
  }

  void updateHistory() {
    previousSelectedBookingFrequency = selectedBookingFrequency;
    previousSelectedBookingDeletionDeadline = selectedBookingDeletionDeadline;
    previousSelectedBookingCreationDeadline = selectedBookingCreationDeadline;
    previousSelectedAllowedCustomerBookingindex =
        selectedAllowedCustomerBookingindex;
  }

  void undoSettings() {
    selectedBookingFrequency = previousSelectedBookingFrequency;
    selectedBookingDeletionDeadline = previousSelectedBookingDeletionDeadline;
    selectedBookingCreationDeadline = previousSelectedBookingCreationDeadline;
    selectedAllowedCustomerBookingindex =
        previousSelectedAllowedCustomerBookingindex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: defaultColumnWidth,
      child: settingsContainer(context),
    );
  }

  Widget settingsContainer(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
        ),
      );
    }
    if (_isLoading) {
      return Center(
        child: ApplicationLoadingIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          SystemLang.LANG_MAP[SystemText.EMPSTGS_APT][langIso639Code],
          style: headerStyle_3_bold,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.EMPSTGS_CREATION_MIN][langIso639Code],
          textAlign: TextAlign.start,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
              [langIso639Code],
          textAlign: TextAlign.start,
          style: bodyStyle_2_grey,
        ),
        ApplicationWidgetContainer(
          verticalInnerPadding: 0,
          child: DropdownButton(
            underline: SizedBox(),
            value: selectedBookingCreationDeadline,
            items: List.generate(24, (index) => index + 1).map(
              (value) {
                return new DropdownMenuItem(
                  value: value,
                  child: Text(
                    "$value ${SystemLang.LANG_MAP[SystemText.HOURS][langIso639Code]}",
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedBookingCreationDeadline = value;
              });
            },
          ),
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.EMPSTGS_DELETE_MIN][langIso639Code],
          textAlign: TextAlign.start,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
              [langIso639Code],
          textAlign: TextAlign.start,
          style: bodyStyle_2_grey,
        ),
        ApplicationWidgetContainer(
          verticalInnerPadding: 0,
          child: DropdownButton(
            underline: SizedBox(),
            value: selectedBookingDeletionDeadline,
            items: List.generate(24, (index) => index + 1).map(
              (value) {
                return new DropdownMenuItem(
                  value: value,
                  child: Text(
                    "$value ${SystemLang.LANG_MAP[SystemText.HOURS][langIso639Code]}",
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedBookingDeletionDeadline = value;
              });
            },
          ),
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.EMPSTGS_BOOKING_FREQ][langIso639Code],
          textAlign: TextAlign.start,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
              [langIso639Code],
          textAlign: TextAlign.start,
          style: bodyStyle_2_grey,
        ),
        ApplicationWidgetContainer(
          verticalInnerPadding: 0,
          child: DropdownButton(
            underline: SizedBox(),
            value: selectedBookingFrequency,
            items: widget.bookingFrequencyOptions.map(
              (value) {
                return new DropdownMenuItem(
                  value: value,
                  child: Text(
                    "$value ${SystemLang.LANG_MAP[SystemText.MINUTES][langIso639Code]}",
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedBookingFrequency = value;
              });
            },
          ),
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.EMPSTGS_MIN_INDEX][langIso639Code],
          textAlign: TextAlign.start,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.INTRODUCTION_HINT][langIso639Code],
          textAlign: TextAlign.start,
          style: bodyStyle_2_grey,
        ),
        ApplicationWidgetContainer(
          verticalInnerPadding: 0,
          child: DropdownButton(
            underline: SizedBox(),
            value: selectedAllowedCustomerBookingindex,
            items: List.generate(5, (index) => index + 1).map(
              (value) {
                return new DropdownMenuItem(
                  value: value,
                  child: Text(
                    getMinimumAllowedCustomerBookingIndexText(context, value),
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                selectedAllowedCustomerBookingindex = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.OTHER][langIso639Code],
          style: headerStyle_3_bold,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 20,
        ),
        ApplicationTextButton(
          label: widget.employee.enabled
              ? SystemLang.LANG_MAP[SystemText.PAUSE_EMPLOYEE][langIso639Code]
              : SystemLang.LANG_MAP[SystemText.ACTIVATE_EMPLOYEE]
                  [langIso639Code],
          onPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return ActionConfirmationPopup(
                  popPageCount: 2,
                  func: () {
                    BlocProvider.of<EmployeeBloc>(context)
                        .add(ResetEmployeeEvent());
                  },
                  asyncOperation: () async {
                    await widget.dataSource.updateEntityStatusAsync(
                      entityId: widget.employee.id,
                      entityType: EntityType.Employee,
                      status: widget.employee.enabled
                          ? EntityStatus.Paused
                          : EntityStatus.Active,
                    );
                  },
                  headerText: widget.employee.enabled
                      ? SystemLang.LANG_MAP[SystemText.PAUSE_EMPLOYEE]
                          [langIso639Code]
                      : SystemLang.LANG_MAP[SystemText.ACTIVATE_EMPLOYEE]
                          [langIso639Code],
                  descriptionText:
                      SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
                          [langIso639Code],
                  continueButtonLabel: widget.employee.enabled
                      ? SystemLang.LANG_MAP[SystemText.PAUSE][langIso639Code]
                      : SystemLang.LANG_MAP[SystemText.ACTIVATE]
                          [langIso639Code],
                  cancelButtonLabel: SystemLang.LANG_MAP[SystemText.CANCEL]
                      [langIso639Code],
                );
              },
            );
          },
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
              [langIso639Code],
          style: bodyStyle_2_grey,
        ),
        SizedBox(
          height: 10,
        ),
        ApplicationTextButton(
          label: SystemLang.LANG_MAP[SystemText.DELETE_EMPLOYEE]
              [langIso639Code],
          onPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return ActionConfirmationPopup(
                  popPageCount: 2,
                  func: () {
                    BlocProvider.of<EmployeeBloc>(context)
                        .add(ResetEmployeeEvent());
                    BlocProvider.of<CalendarBloc>(context, listen: false)
                        .add(ResetCalendarEvent());
                  },
                  asyncOperation: () async {
                    await widget.dataSource
                        .deleteEmployeeAsync(employeeId: widget.employee.id);
                  },
                  headerText: SystemLang.LANG_MAP[SystemText.DELETE_EMPLOYEE]
                      [langIso639Code],
                  descriptionText:
                      SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
                          [langIso639Code],
                  continueButtonLabel: SystemLang.LANG_MAP[SystemText.DELETE]
                      [langIso639Code],
                  cancelButtonLabel: SystemLang.LANG_MAP[SystemText.CANCEL]
                      [langIso639Code],
                );
              },
            );
          },
          color: themeColors[ThemeColor.pinkRed],
          fontWeight: FontWeight.bold,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
              [langIso639Code],
          style: bodyStyle_2_grey,
        ),
        SizedBox(
          height: 30,
        ),
        ApplicationContainerButton(
          loadingOnDisabled: true,
          disabledColor: themeColors[ThemeColor.blue],
          disabled: _isSaving || _isLoading,
          label: SystemLang.LANG_MAP[SystemText.SAVE][langIso639Code],
          color: themeColors[ThemeColor.blue],
          onPress: () async {
            await saveEmployeeSettingsAsync(context);
          },
        ),
      ],
    );
  }

  Future<void> loadEmployeeSettingsAsync() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await widget.dataSource
          .getEmployeeSettingsAsync(employeeId: widget.employee.id);
      selectedAllowedCustomerBookingindex =
          result.minAllowedCustomerBookingIndex;
      selectedBookingCreationDeadline =
          result.allowedAppointmentCreationDeadlineInHours;
      selectedBookingDeletionDeadline =
          result.allowedAppointmentDeletionDeadlineInHours;
      selectedBookingFrequency = result.allowedBookingFrequencyInMinutes;
      updateHistory();
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> saveEmployeeSettingsAsync(BuildContext context) async {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    setState(() {
      _isSaving = true;
    });
    widget.snackBarActions.dispatchLoadingSnackBar(context,
        message: SystemLang.LANG_MAP[SystemText.OPERATION_IN_PROGRESS]
            [langIso639Code]);
    final settings = EmployeeSettingsModel(
      employeeId: widget.employee.id,
      allowedBookingFrequencyInMinutes: selectedBookingFrequency,
      allowedAppointmentDeletionDeadlineInHours:
          selectedBookingDeletionDeadline,
      allowedAppointmentCreationDeadlineInHours:
          selectedBookingCreationDeadline,
      minAllowedCustomerBookingIndex: selectedAllowedCustomerBookingindex,
    );
    try {
      await widget.dataSource.updateEmployeeSettingsAsync(
          employeeId: widget.employee.id, settings: settings);
      widget.snackBarActions.dispatchSuccessSnackBar(context,
          message: SystemLang.LANG_MAP[SystemText.OPERATION_SUCCESS]
              [langIso639Code]);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
      undoSettings();
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
      undoSettings();
    }
    setState(() {
      _isSaving = false;
    });
  }

  String getMinimumAllowedCustomerBookingIndexText(
      BuildContext context, int index) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    if (index <= 1) {
      return SystemLang.LANG_MAP[SystemText.ANY][langIso639Code];
    }
    return index.toString();
  }
}
