import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_phone_number_validator.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/data/models/model_employee_info.dart';
import 'package:allbert_cms/data/models/model_employee_service.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee_info.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/pages/employees/utils/utils_employees.dart';
import 'package:allbert_cms/presentation/pages/employees/widgets/widget_employee_service_list_view.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/shared/widget_phone_number_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/utils/util_image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

typedef OnUpdateEmployee = Function(EmployeeInfo);

class EmployeeInfoTab extends StatefulWidget {
  EmployeeInfoTab({Key key, @required this.employee, @required this.onUpdate})
      : super(key: key);

  final IApiDataSource dataSource = ApiDataSource();
  final List<int> employeeColors = [
    0xff085cfd,
    0xffd8effc,
    0xff7161f1,
    0xffeb7b60,
    0xfff1c061,
    0xfff16180,
  ];

  final PhoneNumberValidator phoneNumberValidator = PhoneNumberValidator();
  final EmployeeUtils employeeUtils = EmployeeUtils();
  final SnackBarActions snackBarActions = SnackBarActions();
  final Employee employee;
  final OnUpdateEmployee onUpdate;

  @override
  _EmployeeInfoTabState createState() => _EmployeeInfoTabState();
}

class _EmployeeInfoTabState extends State<EmployeeInfoTab> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String _selectedIsoCode;

  List<EmployeeServiceModel> _selectedServices;

  int _selectedEmployeeColor;

  bool _isLoading;

  String _predefinedEmployeeId;

  PlatformFile _selectedAvatarFile;
  ApplicationImage _selectedAvatarImage;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    if (widget.employeeColors
        .any((element) => element == widget.employee.info.color)) {
      _selectedEmployeeColor = widget.employee.info.color;
    } else {
      _selectedEmployeeColor = widget.employeeColors.first;
    }
    _predefinedEmployeeId = widget.employee.id;

    _firstNameController.text = widget.employee.info.firstName;
    _lastNameController.text = widget.employee.info.lastName;
    _jobController.text = widget.employee.info.job;
    _phoneController.text = widget.employee.info.phone;
    _emailController.text = widget.employee.info.email;
    _descriptionController.text = widget.employee.info.description;

    _selectedIsoCode = widget.employee.info.phoneIso;
    _selectedServices = widget.employee.info.services;
    _selectedAvatarImage = widget.employee.avatar;
  }

  ApplicationImage getAvatarImage() {
    if (_selectedAvatarImage == null || _selectedAvatarImage.pathUrl == null) {
      if (_selectedAvatarFile == null) {
        return ApplicationImageModel.empty();
      }
      return ApplicationImage(
          id: null, bytes: _selectedAvatarFile.bytes, pathUrl: null);
    }
    return _selectedAvatarImage;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      width: defaultColumnWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ApplicationAvatarImage(
                size: 100,
                image: getAvatarImage(),
              ),
              SizedBox(
                height: 10,
              ),
              ApplicationTextButton(
                label: (getAvatarImage().pathUrl == null &&
                        getAvatarImage().bytes == null)
                    ? SystemLang.LANG_MAP[SystemText.SELECT_AVATAR_IMAGE]
                        [langIso639Code]
                    : SystemLang.LANG_MAP[SystemText.REMOVE_AVATAR_IMAGE]
                        [langIso639Code],
                onPress: () async {
                  if (_selectedAvatarImage != null) {
                    setState(() {
                      _selectedAvatarImage = null;
                      _selectedAvatarFile = null;
                    });
                    return;
                  }
                  if (_selectedAvatarFile == null) {
                    final result = await openSingleImagePickerAsync();
                    if (result != null) {
                      setState(() {
                        _selectedAvatarFile = result;
                      });
                    }
                  } else {
                    setState(() {
                      _selectedAvatarFile = null;
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
              '${SystemLang.LANG_MAP[SystemText.FIRST_NAME][langIso639Code]}\*'),
          ApplicationTextField(
            bottomPadding: 20,
            controller: _firstNameController,
          ),
          Text(
              '${SystemLang.LANG_MAP[SystemText.LAST_NAME][langIso639Code]}\*'),
          ApplicationTextField(
            bottomPadding: 20,
            controller: _lastNameController,
            maxLength: 40,
          ),
          Text('${SystemLang.LANG_MAP[SystemText.JOB][langIso639Code]}\*'),
          ApplicationTextField(
            bottomPadding: 20,
            controller: _jobController,
          ),
          Text(
              '${SystemLang.LANG_MAP[SystemText.PHONE_NUMBER][langIso639Code]}\*'),
          PhoneNumberField(
            bottomPadding: 20,
            controller: _phoneController,
            countryCodeCallback: (value) {
              _selectedIsoCode = value;
            },
          ),
          Text('${SystemLang.LANG_MAP[SystemText.EMAIL][langIso639Code]}\*'),
          ApplicationTextField(
            bottomPadding: 20,
            controller: _emailController,
          ),
          Text(SystemLang.LANG_MAP[SystemText.INTRODUCTION][langIso639Code]),
          Text(
            SystemLang.LANG_MAP[SystemText.EMPLOYEE_DESCRIPTION_HINT]
                [langIso639Code],
            style: bodyStyle_2_grey,
          ),
          Container(
            height: 120,
            child: ApplicationTextField(
              bottomPadding: 20,
              textAlignVertical: TextAlignVertical.top,
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLength: 120,
              maxLines: null,
              showLength: true,
              canBeEmpty: false,
              expands: true,
            ),
          ),
          Text(
            SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SERVICES]
                [langIso639Code],
            style: headerStyle_3_bold,
          ),
          SizedBox(
            height: 12,
          ),
          BlocBuilder<ServicesBloc, ServicesState>(builder: (context, state) {
            if (state is ServicesInitial) {
              final businessId =
                  Provider.of<BusinessProvider>(context, listen: false)
                      .businessId;
              BlocProvider.of<ServicesBloc>(context)
                  .add(FetchServicesEvent(businessId: businessId));
            }
            if (state is ServicesErrorState) {
              return Text(state.failure.errorMessage);
            }
            if (state is ServicesLoadedState) {
              if (state.services == null || state.services.isEmpty) {
                return Text(
                  SystemLang.LANG_MAP[SystemText.EMPTY_SERVICE_LIST]
                      [langIso639Code],
                  style: TextStyle(
                      fontSize: 14, color: themeColors[ThemeColor.pinkRed]),
                );
              }
              return buildEmployeeServiceList(
                context,
                state.services,
                _selectedServices,
                _predefinedEmployeeId,
                (serviceId) {
                  setState(() {
                    if (_selectedServices.contains(EmployeeServiceModel(
                      employeeId: _predefinedEmployeeId,
                      serviceId: serviceId,
                    ))) {
                      _selectedServices
                          .removeWhere((e) => e.serviceId == serviceId);
                    } else {
                      _selectedServices.add(EmployeeServiceModel(
                        employeeId: _predefinedEmployeeId,
                        serviceId: serviceId,
                      ));
                    }
                  });
                },
              );
            }
            return ApplicationLoadingIndicator(
              type: IndicatorType.JumpingDots,
            );
          }),
          SizedBox(
            height: 20,
          ),
          Text(
            SystemLang.LANG_MAP[SystemText.COLOR][langIso639Code],
            style: headerStyle_3_bold,
          ),
          DropdownButton(
            underline: SizedBox(),
            value: _selectedEmployeeColor,
            items: widget.employeeColors.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(e),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 30,
                  height: 30,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedEmployeeColor = value;
              });
            },
          ),
          SizedBox(
            height: 30,
          ),
          ApplicationContainerButton(
            loadingOnDisabled: true,
            disabledColor: themeColors[ThemeColor.blue],
            disabled: _isLoading,
            label: SystemLang.LANG_MAP[SystemText.SAVE][langIso639Code],
            color: themeColors[ThemeColor.blue],
            onPress: () async {
              if (widget.employeeUtils.isInfoValid(context,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  job: _jobController.text,
                  description: _descriptionController.text,
                  phone: _phoneController.text,
                  email: _emailController.text,
                  selectedIsoCode: _selectedIsoCode)) {
                await updateEmployeeInfoAsync(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateEmployeeInfoAsync(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    bool error = false;

    final employeeInfo = EmployeeInfoModel(
      employeeId: _predefinedEmployeeId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      job: _jobController.text,
      phone: _phoneController.text,
      phoneIso: _selectedIsoCode,
      email: _emailController.text,
      description: _descriptionController.text,
      color: _selectedEmployeeColor,
      services: _selectedServices,
    );

    try {
      await widget.dataSource.updateEmployeeAsync(
          employeeId: _predefinedEmployeeId, employeeInfo: employeeInfo);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
      error = true;
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
      error = true;
    }

    if (_selectedAvatarImage == null &&
        (widget.employee.avatar != null &&
            widget.employee.avatar.pathUrl != null)) {
      error = !await widget.employeeUtils
          .deleteEmployeeAvatarAsync(context, _predefinedEmployeeId);
    }

    if (_selectedAvatarFile != null) {
      error = !await widget.employeeUtils.uploadEmployeeAvatarAsync(
          context, _predefinedEmployeeId, _selectedAvatarFile);
    }

    setState(() {
      widget.onUpdate(employeeInfo);
      _isLoading = false;
    });

    if (!error) {
      BlocProvider.of<EmployeeBloc>(context, listen: false)
          .add(ResetEmployeeEvent());
      BlocProvider.of<CalendarBloc>(context, listen: false)
          .add(ResetCalendarEvent());
      widget.snackBarActions
          .dispatchSuccessSnackBar(context, message: "Success!");
    }
  }
}
