part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class FetchEmployeesEvent extends EmployeeEvent {
  final String businessId;

  FetchEmployeesEvent({@required this.businessId});
}

class EditEmployeeEvent extends EmployeeEvent {
  final EmployeeInfo employeeInfo;

  EditEmployeeEvent({@required this.employeeInfo});
}

class AddEmployeeEvent extends EmployeeEvent {
  final EmployeeInfoModel employeeInfo;
  final String businessId;

  AddEmployeeEvent({@required this.businessId, @required this.employeeInfo});
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final String employeeId;

  DeleteEmployeeEvent({@required this.employeeId});
}

class CrossUpdateEmployeesEvent extends EmployeeEvent {
  final List<EmployeeModel> employees;

  CrossUpdateEmployeesEvent({@required this.employees});
}

class CrossUpdateAvatarEvent extends EmployeeEvent {
  final String employeeId;
  final ApplicationImage image;

  CrossUpdateAvatarEvent(this.employeeId, this.image);
}

/* class DeleteEmployeeAvatarEvent extends EmployeeEvent {} */

class ResetEmployeeEvent extends EmployeeEvent {}
