class EmployeeNameDto {
  final String employeeId;
  final String firstName;
  final String lastName;

  EmployeeNameDto(this.employeeId, this.firstName, this.lastName);

  factory EmployeeNameDto.fromJson(Map<String, dynamic> json) {
    return EmployeeNameDto(
      json["employeeId"],
      json["firstName"],
      json["lastName"],
    );
  }
}
