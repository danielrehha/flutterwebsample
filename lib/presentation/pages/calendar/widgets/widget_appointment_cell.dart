import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/domain/entities/entity_containers/et_booking_container.dart';
import 'package:allbert_cms/presentation/pages/calendar/theme_calendar.dart';
import 'package:allbert_cms/presentation/pages/calendar/utils/utils_calendar_cell_details.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CalendarAppointmentCell extends StatelessWidget {
  CalendarAppointmentCell(
      {Key key, @required this.container, String currentDraggingId})
      : super(key: key) {
    if (currentDraggingId != null &&
        currentDraggingId != container.appointment.id) {
      _isDragging = true;
    } else if (currentDraggingId != null &&
        currentDraggingId == container.appointment.id) {
      _isDragging = false;
    } else {
      _isDragging = false;
    }
  }

  final CalendarCellContainer container;
  final CalendarCellDetails cellDetails = CalendarCellDetails();
  final TranslateTime translateTime = TranslateTime();
  final TranslateDate translateDate = TranslateDate();
  bool _isDragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _isDragging
              ? cellDetails
                  .getColor(container)
                  .withOpacity(defaultDraggingOpacity)
              : cellDetails.getColor(container),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                blurRadius: 3,
                spreadRadius: 5,
                color: themeColors[ThemeColor.hollowGrey])
          ]),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Flexible(
              child: ApplicationAvatarImage(
                image: container.employee.avatar,
                size: 24,
              ),
            ),
            /*     Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      cellDetails.getSubject(container),
                      style: bodyStyle_3_white,
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    translateTime(time: cellDetails.getStartTime(container)),
                    style: bodyStyle_3_white,
                    //overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    translateTime(time: cellDetails.getEndTime(container)),
                    style: bodyStyle_3_white,
                    //overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ), */
          ],
        ),
      ),
    );
  }
}
