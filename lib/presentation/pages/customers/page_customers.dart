import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_list_view.dart';
import 'package:allbert_cms/domain/helpers/customer_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/pagination_data.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_customer_list/customer_list_bloc.dart';
import 'package:allbert_cms/presentation/pages/customers/widgets/widget_customer_list_view.dart';
import 'package:allbert_cms/presentation/pages/customers/widgets/widget_customer_list_view_header.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/utils/pagination_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_size.dart';

class CustomersPage extends StatefulWidget {
  CustomersPage({Key key}) : super(key: key);

  final PresentationHelper presentationHelper = PresentationHelper();

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  TextEditingController customerFlairController = TextEditingController();

  int selectedBanStatusInt;
  bool selectedBanStatus;
  String selectedOrderBy;

  int selectedPageSize;

  @override
  void initState() {
    super.initState();
    selectedOrderBy = "appointmentCountDescending";
    selectedBanStatusInt = 0;
    selectedPageSize = 10;
  }

  bool getBannedIntStatus(int value) {
    if (value == 2) {
      return true;
    }
    if (value == 1) {
      return false;
    }
    return null;
  }

  String getBannedStatusText(int value) {
    if (value == 2) {
      return "Letiltott";
    }
    if (value == 1) {
      return "Aktív";
    }
    return "--összes--";
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
              SystemLang.LANG_MAP[SystemText.SIDEBAR_ITEM_CUSTOMERS]
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
                          value: selectedBanStatusInt,
                          items: [0, 1, 2]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    getBannedStatusText(e),
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (selectedBanStatusInt != value) {
                              setState(() {
                                selectedBanStatusInt = value;
                                selectedBanStatus = getBannedIntStatus(value);
                              });
                            }
                          },
                        ),
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
          child: BlocBuilder<CustomerListBloc, CustomerListState>(
            builder: (context, state) {
              if (state is CustomerListInitial) {
                final businessId =
                    Provider.of<BusinessProvider>(context, listen: false)
                        .businessId;
                BlocProvider.of<CustomerListBloc>(context).add(
                  FetchCustomerListEvent(
                    businessId,
                    parameters: CustomerQueryParameters(
                        pageNumber: 1,
                        pageSize: selectedPageSize,
                        orderBy: selectedOrderBy),
                  ),
                );
              }
              if (state is CustomerListError) {
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
              if (state is CustomerListLoaded) {
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
                            value: selectedOrderBy,
                            items: [
                              "appointmentCountDescending",
                              "appointmentCountAscending"
                            ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e == "appointmentCountDescending"
                                          ? "Látogatások száma szerint csökkenő"
                                          : "Látogatások száma szerint növekvő",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (selectedOrderBy != value) {
                                setState(() {
                                  selectedOrderBy = value;
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
                            BlocProvider.of<CustomerListBloc>(context).add(
                              FetchCustomerListEvent(businessId,
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
                            BlocProvider.of<CustomerListBloc>(context).add(
                              FetchCustomerListEvent(businessId,
                                  url: state.paginationData.nextPageLink),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: paddingBelowHeader,
                    ),
                    CustomerListViewHeaderWidget(),
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
    BlocProvider.of<CustomerListBloc>(context).add(
      FetchCustomerListEvent(
        businessId,
        parameters: CustomerQueryParameters(
          pageNumber: 1,
          pageSize: selectedPageSize,
          customerFlair: customerFlairController.text.isEmpty
              ? null
              : customerFlairController.text,
          orderBy: selectedOrderBy,
          banned: selectedBanStatus,
        ),
      ),
    );
  }

  Widget buildAppointmentList(BuildContext context,
      List<CustomerListView> customers, PaginationData paginationData) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: customers.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: applicationListWidgetPadding,
            child: CustomerListViewWidget(
              customerListView: customers[index],
            ),
          );
        },
      ),
    );
  }
}
