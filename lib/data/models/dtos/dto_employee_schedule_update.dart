import 'package:allbert_cms/data/models/model_employee_schedule_settings.dart';
import 'package:allbert_cms/data/models/model_workday.dart';
import 'package:meta/meta.dart';

class EmployeeScheduleUpdateDto {
  final List<WorkDayModel> workDayList;

  EmployeeScheduleUpdateDto({
    @required this.workDayList,
  });

  Map<String, dynamic> toJson() {
    List<dynamic> workDayJsonList = [];
    for(var wd in this.workDayList) {
      workDayJsonList.add(wd.toJson());
    }
    return {
      "workDayList": workDayJsonList,
    };
  }
}
