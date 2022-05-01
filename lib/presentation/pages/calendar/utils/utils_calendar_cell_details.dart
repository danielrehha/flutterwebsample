import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/domain/entities/entity_containers/et_booking_container.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';

class CalendarCellDetails {
  final PersonNameResolver nameResolver = PersonNameResolver();

  String getSubject(CalendarCellContainer appointmentContainer) {
    if (appointmentContainer.appointment != null) {
      String serviceName = appointmentContainer.appointment.service == null
          ? "Törölt szolgáltatás"
          : appointmentContainer.appointment.service.name;
      String employeeName = nameResolver.cultureBasedResolve(
        firstName: appointmentContainer.employee.info.firstName,
        lastName: appointmentContainer.employee.info.lastName,
      );
      return "$employeeName, $serviceName";
    }
    return appointmentContainer.workBlock.description;
  }

  Color getColor(CalendarCellContainer appointmentContainer) {
    if (appointmentContainer.appointment != null) {
      Color color;
      bool isPastAppointment;

      isPastAppointment =
          appointmentContainer.appointment.endDate.isBefore(DateTime.now());

      if (!isPastAppointment) {
        color = Color(appointmentContainer.employee.info.color ??
            themeColors[ThemeColor.blue]);
      } else {
        color = Color(appointmentContainer.employee.info.color ??
                themeColors[ThemeColor.blue])
            .withOpacity(0.4);
      }
      return color;
    }
    return lightGrey;
  }

  DateTime getStartTime(CalendarCellContainer appointmentContainer) {
    if (appointmentContainer.appointment != null) {
      return appointmentContainer.appointment.startDate;
    }
    return appointmentContainer.workBlock.startTime;
  }

  List<Object> getResourceIds(CalendarCellContainer calendarCellContainer) {
    return [calendarCellContainer.employee.id];
  }

  DateTime getEndTime(CalendarCellContainer appointmentContainer) {
    if (appointmentContainer.appointment != null) {
      return appointmentContainer.appointment.endDate;
    }
    return appointmentContainer.workBlock.endTime;
  }
}
