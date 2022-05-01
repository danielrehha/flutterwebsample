import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/data/models/model_employee_info.dart';
import 'package:allbert_cms/data/models/model_employee_work_block.dart';
import 'package:allbert_cms/data/models/model_customer_review.dart';
import 'package:allbert_cms/data/models/model_workday.dart';
import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee_info.dart';
import 'package:allbert_cms/domain/entities/entity_employee_settings.dart';
import 'package:allbert_cms/domain/entities/entity_employee_work_block.dart';
import 'package:allbert_cms/domain/entities/entity_customer_review.dart';
import 'package:allbert_cms/domain/entities/entity_workday.dart';
import 'package:meta/meta.dart';

import 'model_employee_schedule_settings.dart';

class EmployeeModel extends Employee implements ISerializable<EmployeeModel> {
  final String id;
  final String businessId;
  final EmployeeInfoModel info;
  final ApplicationImageModel avatar;
  final EmployeeSettingsModel settings;
  final List<AppointmentModel> appointments;
  final List<ApplicationImageModel> portfolioImages;
  final List<CustomerReview> ratings;
  final List<WorkDayModel> workDayList;
  final List<EmployeeWorkBlockModel> workBlockList;
  final DateTime createdOn;
  final bool enabled;

  EmployeeModel({
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
    @required this.enabled,
  }) : super(
          id: id,
          businessId: businessId,
          info: info,
          avatar: avatar,
          settings: settings,
          appointments: appointments,
          portfolioImages: portfolioImages,
          ratings: ratings,
          workDayList: workDayList,
          workBlockList: workBlockList,
          createdOn: createdOn,
          enabled: enabled,
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    List<AppointmentModel> newBookedTimeslots = [];
    List<ApplicationImageModel> newPortfolioImages = [];
    List<CustomerReviewModel> newRatings = [];
    List<WorkDayModel> newWorkDayList = [];
    List<EmployeeWorkBlockModel> newWorkBlockList = [];
    for (var bookedTimeslot in json['appointments'] ?? []) {
      newBookedTimeslots.add(AppointmentModel.fromJson(bookedTimeslot));
    }
    for (var portfolioImage in json['portfolioImages'] ?? []) {
      newPortfolioImages.add(ApplicationImageModel.fromJson(portfolioImage));
    }
    for (var rating in json['ratings'] ?? []) {
      newRatings.add(CustomerReviewModel.fromJson(rating));
    }
    for (var wd in json["workDayList"] ?? []) {
      newWorkDayList.add(WorkDayModel.fromJson(wd));
    }
    for (var wb in json["workBlockList"] ?? []) {
      newWorkBlockList.add(EmployeeWorkBlockModel.fromJson(wb));
    }
    return EmployeeModel(
      id: json['id'],
      businessId: json['businessId'] ?? null,
      info: json["employeeInfo"] == null
          ? null
          : EmployeeInfoModel.fromJson(json['employeeInfo']),
      avatar: json["avatar"] == null
          ? ApplicationImageModel.empty()
          : ApplicationImageModel.fromJson(json['avatar']),
      settings: json["settings"] == null
          ? EmployeeSettingsModel.getDefault(json["id"])
          : EmployeeSettingsModel.fromJson(json["settings"]),
      appointments: newBookedTimeslots,
      portfolioImages: newPortfolioImages,
      ratings: newRatings,
      workDayList: newWorkDayList,
      workBlockList: newWorkBlockList,
      createdOn: DateTime.parse(json["createdOn"]),
      enabled: json["enabled"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': '${this.id}',
      'businessId': '${this.businessId}',
      'employeeInfo': this.info.toJson(),
    };
  }

  EmployeeModel copyWith({
    String id,
    String businessId,
    EmployeeInfo info,
    ApplicationImageModel avatar,
    EmployeeSettings settings,
    List<Appointment> appointments,
    List<ApplicationImageModel> portfolioImages,
    List<CustomerReview> ratings,
    List<WorkDay> workDayList,
    List<EmployeeWorkBlock> workBlockList,
    bool enabled,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      info: info ?? this.info,
      avatar: avatar ?? this.avatar,
      settings: settings ?? this.settings,
      appointments: appointments ?? this.appointments,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      ratings: ratings ?? this.ratings,
      workDayList: workDayList ?? this.workDayList,
      workBlockList: workBlockList ?? this.workBlockList,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  EmployeeModel fromJson(Map<String, dynamic> json) {
    return EmployeeModel.fromJson(json);
  }
}
