import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/data/models/model_workday.dart';
import 'package:allbert_cms/presentation/bloc/bloc_schedule/schedule_bloc.dart';
import 'package:allbert_cms/presentation/pages/schedule_editor/widgets/widget_workday.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_icon_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/avatar_image.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ScheduleEditorPage extends StatefulWidget {
  ScheduleEditorPage({Key key}) : super(key: key);

  final List<WorkDayModel> workdays = [];

  @override
  _ScheduleEditorPageState createState() => _ScheduleEditorPageState();
}

class _ScheduleEditorPageState extends State<ScheduleEditorPage> {
  List<WorkDayModel> workdays = [];

  final ScrollController scrollController = ScrollController();
  final List<int> bookingFrequencyOptions = [15, 30, 60];

  int selectedBookingFrequency = 30;
  int selectedBookingDeletionDeadline = 1;
  int selectedBookingCreationDeadline = 1;
  int selectedAllowedCustomerBookingindex = 1;

  bool automaticScroll = true;
  bool canScroll = false;

  bool canRenderDatePicker = false;

  @override
  void initState() {
    super.initState();

    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;
    BlocProvider.of<ScheduleBloc>(context)
        .add(FetchScheduleEvent(context, businessId: businessId));
  }

  void selectDate(DateRangePickerSelectionChangedArgs args, String employeeId) {
    final List<DateTime> dates = args.value as List<DateTime>;
    setState(() {
      for (var date in dates) {
        if (workdays.where((element) => element.date == date).length == 0) {
          workdays.add(
              WorkDayModel.getDefaultWithDate(date, employeeId: employeeId));
        }
      }
      for (var wd in workdays) {
        if (dates.where((element) => wd.date == element).length == 0) {
          workdays.remove(wd);
        }
      }
      workdays.sort((a, b) => a.date.compareTo(b.date));
    });
    if (automaticScroll && canScroll) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    }
  }

  void toggleAutomaticScroll(bool value) {
    setState(() {
      automaticScroll = value;
    });
  }

  void onUpdateWorkDay(WorkDayModel workDayModel) {
    setState(() {
      final workDay =
          workdays.firstWhere((element) => element.date == workDayModel.date);
      int index = workdays.indexOf(workDay);
      workdays[index] = workDayModel;
    });
  }

  final TranslateDate translateDate = TranslateDate();

  List<DateTime> getInitialDates(List<WorkDayModel> workDayList) {
    if (workDayList == null || workDayList.isEmpty) {
      return [];
    }
    return workdays.map((e) => e.date).toList();
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Padding(
      padding: defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_SCHEDULER]
                    [langIso639Code],
                style: headerStyle_2_bold,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: BlocConsumer<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                if (state is ScheduleLoaded) {
                  if (state.employees.isNotEmpty) {
                    setState(() {
                      workdays = state.selectedEmployee.workDayList;
                      canRenderDatePicker = true;
                      selectedBookingDeletionDeadline = state.selectedEmployee
                          .settings.allowedAppointmentDeletionDeadlineInHours;
                      selectedBookingFrequency = state.selectedEmployee.settings
                          .allowedBookingFrequencyInMinutes;
                      selectedBookingCreationDeadline = state.selectedEmployee
                          .settings.allowedAppointmentCreationDeadlineInHours;
                      selectedAllowedCustomerBookingindex = state
                          .selectedEmployee
                          .settings
                          .minAllowedCustomerBookingIndex;
                    });
                  } else {
                    setState(() {
                      canRenderDatePicker = false;
                    });
                  }
                }
                if (state is ScheduleLoading) {
                  setState(() {
                    canRenderDatePicker = false;
                  });
                }
              },
              builder: (context, state) {
                if (state is ScheduleInitial) {
                  final businessId =
                      Provider.of<BusinessProvider>(context, listen: false)
                          .businessId;
                  BlocProvider.of<ScheduleBloc>(context)
                      .add(FetchScheduleEvent(context, businessId: businessId));
                }
                if (state is ScheduleError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hiba történt a művelet során",
                        style: headerStyle_3_bold,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        state.failure.errorMessage,
                        style: bodyStyle_2_grey,
                      ),
                    ],
                  );
                }
                if (state is ScheduleLoaded) {
                  if (state.employees == null || state.employees.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [Text("Nincs hozzáadott szakember")],
                    );
                  }
                  return content(state);
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ApplicationLoadingIndicator(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateList() {
    if (workdays.length > 0) {
      canScroll = true;
    } else {
      canScroll = false;
    }
    workdays.sort((a, b) => a.date.compareTo(b.date));
    return workdays.length < 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nincs kiválasztott munkanap",
                style: headerStyle_3_bold,
              ),
              Text(
                  "A dátumokra kattintva válassza ki a megadni kívánt munkanapokat")
            ],
          )
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.custom(
              controller: scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              childrenDelegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: WorkDayWidget(
                      key: Key(workdays[index].id),
                      workday: workdays[index],
                      onUpdate: onUpdateWorkDay,
                    ),
                  );
                },
                findChildIndexCallback: (key) {
                  final ValueKey<String> valueKey = key;
                  return workdays.indexWhere((m) => m.id == valueKey.value);
                },
                childCount: workdays.length,
              ),
            ),
          );
  }

  Widget content(ScheduleLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: themeColors[ThemeColor.hollowGrey],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                DropdownButton(
                  underline: SizedBox(),
                  value: state.selectedEmployee,
                  items: state.employees.map(
                    (employee) {
                      return new DropdownMenuItem(
                        value: employee,
                        child: Row(
                          children: [
                            AvatarImageWidget(
                              image: employee.avatar,
                              size: 35,
                              color: employee.info.color,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              employee.info.lastName +
                                  ' ' +
                                  employee.info.firstName,
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    BlocProvider.of<ScheduleBloc>(context)
                        .add(SelectEmployeeEvent(value));
                  },
                ),
                Spacer(),
                ApplicationIconTextButton(
                  onTap: () {
                    final businessId =
                        Provider.of<BusinessProvider>(context, listen: false)
                            .businessId;
                    BlocProvider.of<ScheduleBloc>(context).add(
                        FetchScheduleEvent(context, businessId: businessId));
                  },
                  label: "Frissítés",
                  icon: null,
                ),
                SizedBox(
                  width: 12,
                ),
                ApplicationIconTextButton(
                  onTap: () {
                    for (var wd in workdays) {
                      for (var pause in wd.pauseList) {
                        int indexOf = wd.pauseList.indexOf(pause);
                        wd.pauseList[indexOf] =
                            wd.pauseList[indexOf].copyWith(workdayId: wd.id);
                      }
                    }
                    BlocProvider.of<ScheduleBloc>(context).add(
                      UpdateScheduleEvent(
                        context,
                        employeeId: state.selectedEmployee.id,
                        workDayList: this.workdays,
                      ),
                    );
                  },
                  label: "Változtatások mentése",
                  icon: null,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: themeColors[ThemeColor.hollowGrey],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Válasszon ki munkanapokat",
                              style: headerStyle_3_bold,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            SfDateRangePicker(
                              showNavigationArrow: true,
                              view: DateRangePickerView.month,
                              selectionMode:
                                  DateRangePickerSelectionMode.multiple,
                              onSelectionChanged: (args) {
                                selectDate(args, state.selectedEmployee.id);
                              },
                              monthViewSettings:
                                  DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 1,
                              ),
                              enablePastDates: false,
                              selectionColor: Colors.indigo,
                              todayHighlightColor: Colors.indigo,
                              maxDate: DateTime.now().add(
                                Duration(days: 30),
                              ),
                              initialSelectedDates: canRenderDatePicker
                                  ? getInitialDates(workdays)
                                  : [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeColors[ThemeColor.hollowGrey],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Kiválasztott dátumok, idősávok",
                              style: headerStyle_3_bold,
                              textAlign: TextAlign.start,
                            ),
                            Spacer(),
                            Text("Automatikus görgetés"),
                            Switch(
                                value: automaticScroll,
                                onChanged: toggleAutomaticScroll),
                          ],
                        ),
                        /* SizedBox(
                          height: 12,
                        ),
                        workdays.length > 0
                            ? GlobalWorkdaySettingsWidget(
                                numberOfWorkdays: workdays.length,
                                onApply: onApplyGlobalSettings,
                              )
                            : SizedBox(), */
                        Expanded(child: buildDateList()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getMinimumAllowedCustomerBookingIndexText(int index) {
    if (index <= 1) {
      return "Mindegy";
    }
    return index.toString();
  }
}
