import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:allbert_cms/presentation/pages/employees/page_create_employee.dart';
import 'package:allbert_cms/presentation/pages/error/container_error.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/pages/employees/widgets/widget_employee.dart';
import 'package:allbert_cms/presentation/shared/application_page_header_text.dart';
import 'package:allbert_cms/presentation/themes/theme_animation.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../themes/theme_size.dart';

// ignore: camel_case_types
class EmployeesPage extends StatelessWidget {
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
            children: [
              ApplicationPageHeaderText(
                  label: SystemText.SIDEBAR_ITEM_EMPLOYEES),
              Spacer(),
              Container(
                width: 150,
                child: ApplicationContainerButton(
                  label: SystemLang.LANG_MAP[SystemText.CREATE][langIso639Code],
                  onPress: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: CreateEmployeePage(),
                          duration: globalPageTransitionDuration,
                        ));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: paddingBelowHeader,
          ),
          Expanded(
            child: BlocBuilder<EmployeeBloc, EmployeesState>(
              builder: (context, state) {
                if (state is EmployeesInitial) {
                  final businessId =
                      Provider.of<BusinessProvider>(context, listen: false)
                          .businessId;
                  BlocProvider.of<EmployeeBloc>(context).add(
                    FetchEmployeesEvent(
                      businessId: businessId,
                    ),
                  );
                }
                if (state is EmployeesLoadedState) {
                  if (state.employees.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Nincs hozzáadott szakember',
                          style: headerStyle_3_bold,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                            "Adjon hozzá szakembert, hogy vállalkozása elérhető legyen időpontfoglaláshoz")
                      ],
                    );
                  }
                  return SingleChildScrollView(
                      child: buildEmployeeList(context,
                          employees: state.employees));
                }
                if (state is EmployeesErrorState) {
                  return Center(
                    child: ErrorContainer(
                      failure: state.failure,
                      errorHandlerCallback: () {
                        final businessId = Provider.of<BusinessProvider>(
                                context,
                                listen: false)
                            .businessId;
                        BlocProvider.of<EmployeeBloc>(context)
                            .add(FetchEmployeesEvent(businessId: businessId));
                      },
                    ),
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
        ],
      ),
    );
  }

  Widget buildEmployeeList(BuildContext context,
      {@required List<EmployeeModel> employees}) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                applicationListWidgetPadding,
            child: EmployeeWidget(employee: employees[index]),
          );
        },
      ),
    );
  }
}
