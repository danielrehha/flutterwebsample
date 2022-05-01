import 'package:allbert_cms/data/models/model_avatar.dart';
import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_avatar_image.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_schedule.dart';
import 'package:meta/meta.dart';

class ScheduleModel extends Schedule {
  final String id;
  final String firstName;
  final String lastName;
  final AvatarImageModel avatar;
  final List<AppointmentModel> appointments;

  ScheduleModel({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.avatar,
    @required this.appointments,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          avatar: avatar,
          appointments: appointments,
        );

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    List<AppointmentModel> bookedTimeslots = [];
    for (var booked in json['bookedTimeslots']) {
      bookedTimeslots.add(AppointmentModel.fromJson(booked));
    }
    return ScheduleModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: AvatarImageModel.fromJson(json['avatar']),
      appointments: bookedTimeslots,
    );
  }

  ScheduleModel copyWith({
    String id,
    String firstName,
    String lastName,
    AvatarImage avatar,
    List<Appointment> bookedTimeslots,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      appointments: bookedTimeslots ?? this.appointments,
    );
  }

/*   @override
  ScheduleModel fromJson(Map<String, dynamic> json) {
    return ScheduleModel.fromJson(json);
  } */
}
