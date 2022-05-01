import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/domain/entities/entity_containers/et_booking_container.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee_work_block.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/pages/calendar/utils/utils_calendar_cell_details.dart';
import 'package:allbert_cms/presentation/pages/calendar/widgets/widget_appointment_cell.dart';
import 'package:allbert_cms/presentation/pages/calendar/widgets/widget_block_cell.dart';
import 'package:allbert_cms/presentation/pages/employees/page_edit_employee.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_check_box.dart';
import 'package:allbert_cms/presentation/shared/application_employee_selector.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_state_object_handler.dart';
import 'package:allbert_cms/presentation/shared/avatar_image.dart';
import 'package:allbert_cms/presentation/themes/theme_animation.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/utils/application_entity_text_reader.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({
    Key key,
  }) : super(key: key);

  final PersonNameResolver nameResolver = PersonNameResolver();
  final CalendarCellDetails calendarCellDetails = CalendarCellDetails();
  final double createAppointmentSheetWidth = 400;
  final double detailsAppointmentSheetWidth = 400;

  final ApplicationEntityTextReader applicationEntityTextReader =
      ApplicationEntityTextReader();

  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  CalendarController _calendarController;

  TranslateDate translateDate = TranslateDate();
  TranslateTime translateTime = TranslateTime();

  Map<String, bool> _employeeSelectionMap = {};

  List<CalendarView> _availableCalendarViews = [
    CalendarView.day,
    CalendarView.week,
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
  ];

  bool _isDragging;
  String _currentDraggingId;

  List<EmployeeModel> _employees;

  bool _isLoading;
  bool _postDragUpdate;

  DateTime _from;
  DateTime _until;

  String _errorMessage;

  List<String> _selectedEmployees;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    _from = DateTime.now().subtract(Duration(days: 30));
    _until = DateTime.now().add(Duration(days: 30));

    _isDragging = false;
    _postDragUpdate = false;
    _isLoading = false;

    _employees = [];

    _selectedEmployees = [];

    _calendarController.view = CalendarView.week;
  }

  void toggleEmployee(String id) {
    setState(() {
      _employeeSelectionMap[id] = !_employeeSelectionMap[id];
    });
  }

  void selectAll() {
    setState(() {
      for (var key in _employeeSelectionMap.keys) {
        _employeeSelectionMap[key] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Stack(
      children: [
        Padding(
          padding: defaultPadding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_CALENDAR]
                        [langIso639Code],
                    style: headerStyle_2_bold,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Alkalmazottak:",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ApplicationEmployeeSelector(
                    onEmployeeSelected: (value) {
                      setState(() {
                        _selectedEmployees = value;
                      });
                      _loadCalendarAsync();
                    },
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: paddingBelowHeader,
              ),
              Expanded(
                child: ApplicationStateObjectHandler(
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                  stateObject: myCalendar(
                    datasource: _getCalendarDataSource(
                      employees: _employees,
                    ),
                    employees: _employees,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void openAppointmentSheet(CalendarTapDetails details) {
    if (details.appointments == null || details.appointments.isEmpty) {
/*       openCreateAppointmentSheet();
      closeAppointmentDetailsSheet();
      closeWorkblockDetailsSheet(); */
      return;
    }
    final containers =
        List<CalendarCellContainer>.from(details.appointments).toList();
    if (containers != null && containers.length > 0) {
      if (containers.first.workBlock != null) {
        /*  closeCreateAppointmentSheet();
        closeAppointmentDetailsSheet(); */
      }
      if (containers.first.appointment != null) {
        /* closeCreateAppointmentSheet();
        _detailsSheetAnimationController.forward(); */
      }
    }
  }

  List<TimeRegion> _getTimeRegions(List<Employee> employees) {
    final List<TimeRegion> regions = <TimeRegion>[];
    for (var emp in employees) {
      if (_employeeSelectionMap[emp.id]) {
        for (var wd in emp.workDayList) {
          regions.add(
            TimeRegion(
              startTime: wd.startTime,
              endTime: wd.endTime,
              color: Color(emp.info.color).withAlpha(50),
              resourceIds: [emp.id],
            ),
          );
        }
      }
    }
    return regions;
  }

  Widget myCalendar(
      {@required CalendarDataSource datasource,
      @required List<Employee> employees}) {
    return SfCalendar(
      resourceViewHeaderBuilder: _isLoading
          ? null
          : (BuildContext context, ResourceViewHeaderDetails details) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ApplicationAvatarImage(
                    imageProvider: details.resource.image,
                    color: details.resource.color.value,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(details.resource.displayName),
                ],
              );
            },
      onViewChanged: _onViewChanged,
      firstDayOfWeek: 1,
      cellBorderColor: _isDragging ? Colors.grey : lightGrey,
      initialSelectedDate: DateTime.now(),
      controller: _calendarController,
      cellEndPadding: -1,
      initialDisplayDate: DateTime.now(),
      view: _calendarController.view,
      allowDragAndDrop: true,
      onDragEnd: _onCalendarDragEnd,
      onDragStart: _onCalendarDragStart,
      showNavigationArrow: true,
      dataSource: datasource,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeInterval: Duration(minutes: 30),
        startHour: 6,
        endHour: 23,
        timeFormat: 'h mm a',
      ),
      appointmentBuilder: _customAppointmentBuilder,
      onTap: _onCalendarTap,
      specialRegions: _getTimeRegions(employees),
      dragAndDropSettings: DragAndDropSettings(),
    );
  }

  void _onCalendarTap(CalendarTapDetails details) {
    final date = details.date;
    if (details.resource != null) {
      final employee =
          _employees.firstWhere((e) => e.id == details.resource.id);
    }
    openAppointmentSheet(details);
  }

  void _onViewChanged(ViewChangedDetails details) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final adjustedStartDate =
          details.visibleDates.first.subtract(Duration(days: 30));
      final adjustedEndDate = details.visibleDates.last.add(Duration(days: 30));
      bool _updateView = false;
      if (_from == null || _until == null) {
        _updateView = true;
        _from = adjustedStartDate;
        _until = adjustedEndDate;
      }
      if (details.visibleDates.first.isBefore(_from) ||
          details.visibleDates.last.isAfter(_until)) {
        _from = adjustedStartDate;
        _until = adjustedEndDate;
        _updateView = true;
      }
      if (_updateView) {
        if (!_isDragging) {
          await _loadCalendarAsync();
        } else {
          _postDragUpdate = true;
        }
      }
    });
  }

  Future<void> _loadCalendarAsync() async {
    setState(() {
      _isLoading = true;
    });

    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;

    try {
      _employees = await widget.dataSource.loadCalendarAsync(
        businessId: businessId,
        employeeIds: _selectedEmployees ?? [],
        from: _from,
        until: _until,
      );
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, message: e.message);
      _employees = [];
      _errorMessage = e.message;
    } on Exception catch (e) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: e.toString());
      _employees = [];
      _errorMessage = e.toString();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onCalendarDragStart(AppointmentDragStartDetails details) {
    setState(() {
      _isDragging = true;
      final obj = details.appointment as CalendarCellContainer;
      if (obj.appointment != null) {
        _currentDraggingId = obj.appointment.id;
      }
      if (obj.workBlock != null) {
        _currentDraggingId = obj.workBlock.id;
      }
    });
  }

  void _onCalendarDragEnd(AppointmentDragEndDetails details) async {
    setState(() {
      _isDragging = false;
      _currentDraggingId = null;
    });
    final container = details.appointment as CalendarCellContainer;
    if (container.workBlock != null) {
      final newBlock = container.workBlock.copyWith(
        startTime: details.droppingTime,
        endTime: details.droppingTime.add(container.workBlock.duration),
      );
      await rescheduleWorkBlockAsync(context, workBlock: newBlock);
    }
    if (container.appointment != null) {
      final newApt = container.appointment.copyWith(
        startDate: details.droppingTime,
        endDate: details.droppingTime.add(container.appointment.duration),
      );
      await rescheduleAppointmentAsync(context, appointment: newApt);
    }
    if (_postDragUpdate) {
      await _loadCalendarAsync();
      _postDragUpdate = false;
    }
  }

  Widget _customAppointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: lightGrey,
        highlightColor: Colors.white38,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
    final CalendarCellContainer apt = details.appointments.first;
    if (apt.appointment != null) {
      return CalendarAppointmentCell(
        container: apt,
        currentDraggingId: _currentDraggingId,
      );
    }
    return CalendarBlockCell(
      container: apt,
      currentDraggingId: _currentDraggingId,
    );
  }

  DataSource _getCalendarDataSource({@required List<Employee> employees}) {
    List<CalendarResource> resources = <CalendarResource>[];
    List<CalendarCellContainer> _containers = [];
    for (var emp in employees) {
      resources.add(
        CalendarResource(
          id: emp.id,
          displayName:
              widget.applicationEntityTextReader.employeeName(context, emp),
          color: Color(emp.info.color),
          image: emp.avatar == null || emp.avatar.pathUrl == null
              ? null
              : Image.network(emp.avatar.pathUrl).image,
        ),
      );
      if (_employeeSelectionMap[emp.id]) {
        for (var apt in emp.appointments) {
          var container =
              CalendarCellContainer(appointment: apt, employee: emp);
          _containers.add(container);
        }
        for (var wb in emp.workBlockList) {
          var container = CalendarCellContainer(workBlock: wb, employee: emp);
          _containers.add(container);
        }
      }
    }
    return DataSource(_containers, resources);
  }

  Future<void> rescheduleWorkBlockAsync(BuildContext context,
      {@required EmployeeWorkBlock workBlock}) async {
    bool _error = false;
    try {
      await widget.dataSource.updateWorkBlockAsync(
          employeeId: workBlock.employeeId, workBlock: workBlock);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, message: e.message);
      _error = true;
    } on Exception catch (e) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: e.toString());
      _error = true;
    }
    if (!_error) {
      _loadCalendarAsync();
    }
  }

  Future<void> rescheduleAppointmentAsync(BuildContext context,
      {@required AppointmentModel appointment}) async {
    bool _error = false;
    try {
      await widget.dataSource.updateAppointmentAsync(
          appointmentId: appointment.id, appointment: appointment);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, message: e.message);
      _error = true;
    } on Exception catch (e) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: e.toString());
      _error = true;
    }
    if (!_error) {
      _loadCalendarAsync();
    }
  }
}

class LoadingDataSource extends CalendarDataSource {
  LoadingDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments[index] as Appointment).startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments[index] as Appointment).endTime;
  }

  @override
  Color getColor(int index) {
    return Colors.grey;
  }

  @override
  String getSubject(int index) {
    return "";
  }
}

class DataSource extends CalendarDataSource {
  DataSource(
      List<CalendarCellContainer> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  final CalendarCellDetails calendarCellDetails = CalendarCellDetails();

  @override
  DateTime getStartTime(int index) {
    return calendarCellDetails.getStartTime(appointments[index]);
  }

  @override
  DateTime getEndTime(int index) {
    return calendarCellDetails.getEndTime(appointments[index]);
  }

  @override
  Color getColor(int index) {
    return calendarCellDetails.getColor(appointments[index]);
  }

  @override
  String getSubject(int index) {
    return calendarCellDetails.getSubject(appointments[index]);
  }

  @override
  List<Object> getResourceIds(int index) {
    return calendarCellDetails.getResourceIds(appointments[index]);
  }

  @override
  CalendarCellContainer convertAppointmentToObject(
      Object customData, Appointment appointment) {
    final data = customData as CalendarCellContainer;
    return CalendarCellContainer(
      employee: data.employee,
      workBlock: data.workBlock,
      appointment: data.appointment,
    );
  }
}
