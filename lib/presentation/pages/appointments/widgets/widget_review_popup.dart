import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:flutter/material.dart';

import '../../../themes/theme_size.dart';

typedef ReviewAppointmentCallback = Function(AppointmentStatus);

class ReviewAppointmentPopup extends StatefulWidget {
  ReviewAppointmentPopup({
    Key key,
    @required this.appointmentDescription,
    @required this.reviewCallback,
  }) : super(key: key);

  final ReviewAppointmentCallback reviewCallback;
  final String appointmentDescription;
  final SnackBarActions snackBarActions = SnackBarActions();
  final ApiDataSource dataSource = ApiDataSource();

  @override
  _ReviewAppointmentPopupState createState() => _ReviewAppointmentPopupState();
}

class _ReviewAppointmentPopupState extends State<ReviewAppointmentPopup> {
  AppointmentStatus selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = AppointmentStatus.Review;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: defaultPadding,
        child: UnconstrainedBox(
          child: Column(
            children: [
              Text("Foglalás lezárása"),
              Text(widget.appointmentDescription),
              Row(
                children: [
                  Container(
                    height: 40,
                    child: DropdownButton(
                      underline: SizedBox(),
                      value: selectedStatus,
                      items: [AppointmentStatus.Review, AppointmentStatus.ReviewPositive, AppointmentStatus.ReviewNegative]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(getStatusText(e)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        selectStatus(value);
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    child: ApplicationTextButton(
                      label: "Lezárás",
                      onPress: () {
                        widget.reviewCallback(selectedStatus);
                        Navigator.pop(context);
                      },
                      disabled: selectedStatus == 1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void selectStatus(AppointmentStatus status) {
    if (selectedStatus != status) {
      setState(() {
        selectedStatus = status;
      });
    }
  }

  String getStatusText(AppointmentStatus status) {
    if (status == AppointmentStatus.Review) {
      return "--válasszon--";
    }
    if (status == AppointmentStatus.ReviewPositive) {
      return "Teljesített";
    }
    return "Nem teljesített";
  }
}
