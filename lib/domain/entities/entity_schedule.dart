import 'package:allbert_cms/domain/entities/entity_avatar_image.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Schedule extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final AvatarImage avatar;
  final List<Appointment> appointments;

  Schedule({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.avatar,
    @required this.appointments,
  });

  @override
  List<Object> get props => [
        id,
        firstName,
        lastName,
        avatar,
        appointments,
      ];
}
