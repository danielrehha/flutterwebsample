import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/data/models/model_employee_work_block.dart';
import 'package:allbert_cms/domain/entities/entity_employee_work_block.dart';
import 'package:allbert_cms/domain/entities/entity_workpause.dart';
import 'package:meta/meta.dart';

class CalendarCellContainer {
  EmployeeModel employee;
  AppointmentModel appointment;
  EmployeeWorkBlockModel workBlock;

  CalendarCellContainer({this.appointment, @required this.employee, this.workBlock});
}
