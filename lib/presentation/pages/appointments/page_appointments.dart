import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/domain/enums/helpers/enum_helper_status_text.dart';
import 'package:allbert_cms/domain/helpers/appointment_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/pagination_data.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/sub_blocs/employee_query/appointment_employee_query_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/sub_blocs/service_query/appointment_service_query_bloc.dart';
import 'package:allbert_cms/presentation/pages/appointments/enums.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/utils/pagination_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'widgets/widget_appointment_list_view.dart';

class AppointmentsPage extends StatefulWidget {
  AppointmentsPage({Key key}) : super(key: key);

  final PresentationHelper presentationHelper = PresentationHelper();

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  AppointmentType currentTab = AppointmentType.Active;
  final PersonNameResolver nameResolver = PersonNameResolver();
  final TranslateDate translateDate = TranslateDate();

  List<EmployeeModel> employees = [];
  List<ServiceModel> services = [];
  String selectedEmployeeId;
  String selectedServiceId;
  DateTime selectedDate;
  String customerFlair;
  AppointmentStatus selectedAppointmentStatus;
  bool orderByDescending;

  int selectedPageSize;

  TextEditingController customerFlairController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedAppointmentStatus = AppointmentStatus.NULL;
    selectedPageSize = 10;
    orderByDescending = true;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Padding(
      padding: defaultPadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_APPOINTMENTS]
                  [langIso639Code],
              style: headerStyle_2_bold,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: defaultShadowBlurRadius,
                spreadRadius: defaultShadowSpreadRadius,
                color: themeColors[ThemeColor.hollowGrey]
                    .withAlpha(defaultShadowAlpha),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text("Státusz:"),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        height: 20,
                        child: DropdownButton(
                          underline: SizedBox(),
                          value: selectedAppointmentStatus,
                          items: [
                            AppointmentStatus.NULL,
                            AppointmentStatus.Active,
                            AppointmentStatus.Review,
                            AppointmentStatus.ReviewPositive,
                            AppointmentStatus.ReviewNegative,
                            AppointmentStatus.DeletedByCustomer,
                            AppointmentStatus.DeletedByBusiness
                          ]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    getStatusText(e),
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            selectStatus(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text("Alkalmazott:"),
                      SizedBox(width: 6),
                      Container(
                        child: BlocConsumer<AppointmentEmployeeQueryBloc,
                            AppointmentEmployeeQueryState>(
                          listener: (context, state) {
                            if (state is AppointmentEmployeeQueryLoaded) {
                              employees.clear();
                              employees = state.employees;
                              employees.insert(0, EmployeeModel(id: null));
                              selectedEmployeeId = null;
                            }
                          },
                          builder: (context, state) {
                            if (state is AppointmentEmployeeQueryInitial) {
                              final businessId = Provider.of<BusinessProvider>(
                                      context,
                                      listen: false)
                                  .businessId;
                              BlocProvider.of<AppointmentEmployeeQueryBloc>(
                                      context)
                                  .add(FetchAppointmentEmployeeQueryEvent(
                                      businessId));
                            }
                            if (state is AppointmentEmployeeQueryError) {
                              return Text("Szerver hiba");
                            }
                            if (state is AppointmentEmployeeQueryLoading) {
                              return Text("Betöltés...");
                            }
                            if (state is AppointmentEmployeeQueryLoaded) {
                              if (state.employees.isEmpty) {
                                return Text("--összes--");
                              }
                              return SizedBox(
                                height: 20,
                                child: DropdownButton(
                                  underline: SizedBox(),
                                  value: selectedEmployeeId,
                                  items: state.employees
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.id == null
                                                  ? "--összes--"
                                                  : nameResolver
                                                      .cultureBasedResolve(
                                                          firstName:
                                                              e.info.firstName,
                                                          lastName:
                                                              e.info.lastName),
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (selectedEmployeeId != value) {
                                      setState(() {
                                        selectedEmployeeId = value;
                                      });
                                    }
                                  },
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text("Szolgáltatás:"),
                      SizedBox(width: 6),
                      Container(
                        child: BlocConsumer<AppointmentServiceQueryBloc,
                            AppointmentServiceQueryState>(
                          listener: (context, state) {
                            if (state is AppointmentServiceQueryLoaded) {
                              services.clear();
                              services = state.services;
                              services.insert(0, ServiceModel(id: null));
                              selectedServiceId = null;
                            }
                          },
                          builder: (context, state) {
                            if (state is AppointmentServiceQueryInitial) {
                              final businessId = Provider.of<BusinessProvider>(
                                      context,
                                      listen: false)
                                  .businessId;
                              BlocProvider.of<AppointmentServiceQueryBloc>(
                                      context)
                                  .add(FetchAppointmentServiceQueryEvent(
                                      businessId));
                            }
                            if (state is AppointmentServiceQueryError) {
                              return Text("Szerver hiba");
                            }
                            if (state is AppointmentServiceQueryLoading) {
                              return Text("Betöltés...");
                            }
                            if (state is AppointmentServiceQueryLoaded) {
                              if (state.services.isEmpty) {
                                return Text("--összes--");
                              }
                              return SizedBox(
                                height: 20,
                                child: DropdownButton(
                                  underline: SizedBox(),
                                  value: selectedServiceId,
                                  items: services
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.id == null
                                                  ? "--összes--"
                                                  : e.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (selectedServiceId != value) {
                                      setState(() {
                                        selectedServiceId = value;
                                      });
                                    }
                                  },
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(
                        "Dátum:",
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        child: Text(
                          selectedDate == null
                              ? "--nincs megadva--"
                              : translateDate(date: selectedDate),
                        ),
                        onTap: () async {
                          final result = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 3650)),
                            lastDate: DateTime.now().add(Duration(days: 3650)),
                          );
                          setState(() {
                            selectedDate = result;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text("Vendég:"),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Container(
                          child: SizedBox(
                            height: 40,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Pl. telefonszám, e-mail, név..",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                controller: customerFlairController,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                ApplicationTextButton(
                  label: "Keresés",
                  onPress: () {
                    applyFiltersAndSearch();
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: paddingBelowHeader,
        ),
        Expanded(
          child: BlocBuilder<AppointmentListBloc, AppointmentListState>(
            builder: (context, state) {
              if (state is AppointmentListInitial) {
                final businessId =
                    Provider.of<BusinessProvider>(context, listen: false)
                        .businessId;
                BlocProvider.of<AppointmentListBloc>(context).add(
                  FetchAppointmentListEvent(
                    businessId,
                    parameters: AppointmentQueryParameters(
                      pageNumber: 1,
                      pageSize: selectedPageSize,
                      orderByDescending: orderByDescending,
                    ),
                  ),
                );
              }
              if (state is AppointmentListError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.failure.errorMessage,
                      style: headerStyle_3_bold,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }
              if (state is AppointmentListLoaded) {
                if (state.appointments.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nincs találat a megadott keresési feltételekkel",
                        style: headerStyle_3_bold,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Összes találat: ${state.paginationData.totalCount}"),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                            "Megjelenített: ${(state.paginationData.currentPage * state.paginationData.pageSize) - state.paginationData.pageSize + 1} - ${widget.presentationHelper.getCurrentPageLimit(state.paginationData)}"),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Oldalméret:"),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          height: 20,
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: selectedPageSize,
                            items: [10, 50, 100, 200]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (selectedPageSize != value) {
                                setState(() {
                                  selectedPageSize = value;
                                });
                                applyFiltersAndSearch();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Rendezés:"),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          height: 20,
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: orderByDescending,
                            items: [
                              true,
                              false,
                            ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e
                                          ? "Rendezés legújabb szerint"
                                          : "Rendezés legrégebbi szerint",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (orderByDescending != value) {
                                setState(() {
                                  orderByDescending = value;
                                });
                                applyFiltersAndSearch();
                              }
                            },
                          ),
                        ),
                        Spacer(),
                        ApplicationTextButton(
                          label: "Előző oldal",
                          disabled:
                              state.paginationData.previousPageLink == null,
                          onPress: () {
                            final businessId = Provider.of<BusinessProvider>(
                                    context,
                                    listen: false)
                                .businessId;
                            BlocProvider.of<AppointmentListBloc>(context).add(
                              FetchAppointmentListEvent(businessId,
                                  url: state.paginationData.previousPageLink),
                            );
                          },
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ApplicationTextButton(
                          label: "Következő oldal",
                          disabled: state.paginationData.nextPageLink == null,
                          onPress: () {
                            final businessId = Provider.of<BusinessProvider>(
                                    context,
                                    listen: false)
                                .businessId;
                            BlocProvider.of<AppointmentListBloc>(context).add(
                              FetchAppointmentListEvent(businessId,
                                  url: state.paginationData.nextPageLink),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: paddingBelowHeader,
                    ),
                    Expanded(
                        child: buildAppointmentList(
                      context,
                      state.appointments,
                      state.paginationData,
                    )),
                  ],
                );
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
      ]),
    );
  }

  void applyFiltersAndSearch() {
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;
    BlocProvider.of<AppointmentListBloc>(context).add(
      FetchAppointmentListEvent(
        businessId,
        parameters: AppointmentQueryParameters(
          pageNumber: 1,
          pageSize: selectedPageSize,
          date: selectedDate,
          status: selectedAppointmentStatus == AppointmentStatus.NULL
              ? null
              : selectedAppointmentStatus,
          employeeId: selectedEmployeeId,
          serviceId: selectedServiceId,
          customerFlair: customerFlairController.text.isEmpty
              ? null
              : customerFlairController.text,
          orderByDescending: orderByDescending ? orderByDescending : null,
        ),
      ),
    );
  }

  void selectStatus(AppointmentStatus status) {
    if (selectedAppointmentStatus != status) {
      setState(() {
        selectedAppointmentStatus = status;
      });
    }
  }

  Widget buildAppointmentList(BuildContext context,
      List<Appointment> appointments, PaginationData paginationData) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: appointments.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: applicationListWidgetPadding,
            child: AppointmentListView(
              appointment: appointments[index],
            ),
          );
        },
      ),
    );
  }
}
