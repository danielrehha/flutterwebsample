import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/domain/entities/entity_containers/et_booking_container.dart';
import 'package:allbert_cms/presentation/pages/calendar/theme_calendar.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/utils/application_entity_text_reader.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CalendarBlockCell extends StatelessWidget {
  CalendarBlockCell(
      {Key key, @required this.container, String currentDraggingId})
      : super(key: key) {
    if (currentDraggingId != null &&
        currentDraggingId != container.workBlock.id) {
      _isDragging = true;
    } else if (currentDraggingId != null &&
        currentDraggingId == container.workBlock.id) {
      _isDragging = false;
    } else {
      _isDragging = false;
    }
  }

  final CalendarCellContainer container;
  final TranslateTime translateTime = TranslateTime();
  final TranslateDate translateDate = TranslateDate();
  final ApplicationEntityTextReader entityTextReader =
      ApplicationEntityTextReader();
  bool _isDragging;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _isDragging
                  ? Colors.grey.withOpacity(defaultDraggingOpacity)
                  : Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  container.workBlock.description,
                  style: bodyStyle_3_white,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _isDragging
                ? Color(container.employee.info.color)
                    .withOpacity(defaultDraggingOpacity)
                : Color(container.employee.info.color),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              container.employee.avatar == null ||
                      container.employee.avatar.pathUrl == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.person),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage:
                            Image.network(container.employee.avatar.pathUrl)
                                .image,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
