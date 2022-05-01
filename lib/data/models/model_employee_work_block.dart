import 'package:allbert_cms/domain/entities/entity_employee_work_block.dart';
import 'package:meta/meta.dart';

class EmployeeWorkBlockModel extends EmployeeWorkBlock {
  final String id;
  final String employeeId;
  final DateTime startTime;
  final DateTime endTime;
  final String description;

  EmployeeWorkBlockModel({
    @required this.id,
    @required this.employeeId,
    @required this.startTime,
    @required this.endTime,
    @required this.description,
  }) : super(
          id: id,
          employeeId: employeeId,
          startTime: startTime,
          endTime: endTime,
          description: description,
        );

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "employeeId": this.employeeId,
      "startTime": this.startTime.toIso8601String(),
      "endTime": this.endTime.toIso8601String(),
      "description": this.description,
    };
  }

  factory EmployeeWorkBlockModel.fromJson(Map<String, dynamic> json) {
    return EmployeeWorkBlockModel(
      id: json["id"],
      employeeId: json["employeeId"],
      startTime: DateTime.parse(json["startTime"]),
      endTime: DateTime.parse(json["endTime"]),
      description: json["description"],
    );
  }

  EmployeeWorkBlockModel copyWith({
    String id,
    String employeeId,
    DateTime startTime,
    DateTime endTime,
    String description,
  }) {
    return EmployeeWorkBlockModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
    );
  }
}
