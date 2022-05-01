import 'package:allbert_cms/core/utils/util_phone_dialcode_parser.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/presentation/pages/employees/page_edit_employee.dart';
import 'package:allbert_cms/presentation/shared/application_status_indicator.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/shared/avatar_image.dart';
import 'package:allbert_cms/presentation/themes/theme_animation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class EmployeeWidget extends StatefulWidget {
  final Employee employee;

  const EmployeeWidget({Key key, @required this.employee}) : super(key: key);

  @override
  _EmployeeWidgetState createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget> {
  final PhoneDialcodeParser dialcodeParser = PhoneDialcodeParser();
  @override
  Widget build(BuildContext context) {
    return ApplicationWidgetContainer(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: UpdateEmployeePage(
                  employee: widget.employee,
                ),
                duration: globalPageTransitionDuration,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AvatarImageWidget(
                size: 35,
                image: widget.employee.avatar,
                color: widget.employee.info.color,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.employee.info.lastName +
                      ' ' +
                      widget.employee.info.firstName,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.employee.info.email,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.employee.info.job,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${dialcodeParser(phoneNumber: widget.employee.info.phone, isoCode: widget.employee.info.phoneIso)}${widget.employee.info.phone}',
                  textAlign: TextAlign.center,
                ),
              ),
              ApplicationEntityStatusIndicator(
                enabled: widget.employee.enabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
