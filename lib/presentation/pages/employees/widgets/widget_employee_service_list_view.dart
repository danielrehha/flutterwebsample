import 'package:allbert_cms/data/models/model_employee_service.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/presentation/shared/application_check_box.dart';
import 'package:flutter/material.dart';

Widget employeeServiceListView(
    ServiceModel service,
    List<EmployeeServiceModel> selectedServices,
    String predefinedEmployeeId,
    Function(String) onTap) {
  return Row(
    children: [
      ApplicationCheckBox(
        onTap: (value) {
          onTap(service.id);
        },
        value: selectedServices.contains(EmployeeServiceModel(
          employeeId: predefinedEmployeeId,
          serviceId: service.id,
        )),
      ),
      SizedBox(
        width: 12,
      ),
      Text(service.name),
    ],
  );
}

  Widget buildEmployeeServiceList(
    BuildContext context,
      List<Service> services,
      List<EmployeeServiceModel> selectedServices,
      String employeeId,
      Function(String) onTap) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: services.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8),
            child: employeeServiceListView(
                services[index], selectedServices, employeeId, onTap),
          );
        },
      ),
    );
  }
