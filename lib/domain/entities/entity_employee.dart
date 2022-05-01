import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_employee_service.dart';
import 'package:allbert_cms/domain/entities/entity_employee_work_block.dart';
import 'package:allbert_cms/domain/entities/entity_workday.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'entity_appointment.dart';
import 'entity_employee_info.dart';

import 'entity_employee_settings.dart';
import 'entity_customer_review.dart';

class Employee extends Equatable {
  final String id;
  final String businessId;
  final EmployeeInfo info;
  final ApplicationImage avatar;
  final EmployeeSettings settings;
  final List<Appointment> appointments;
  final List<ApplicationImage> portfolioImages;
  final List<CustomerReview> ratings;
  final List<WorkDay> workDayList;
  final List<EmployeeWorkBlock> workBlockList;
  final DateTime createdOn;
  final bool enabled;

  Employee({
    @required this.id,
    @required this.businessId,
    @required this.info,
    @required this.avatar,
    this.settings,
    @required this.appointments,
    @required this.portfolioImages,
    @required this.ratings,
    this.workDayList = const [],
    this.workBlockList = const [],
    this.createdOn,
    this.enabled,
  });

  @override
  List<Object> get props => [
        id,
        businessId,
        info,
        avatar,
        settings,
        appointments,
        portfolioImages,
        ratings,
        workDayList,
        workBlockList,
        createdOn,
        enabled,
      ];
}
