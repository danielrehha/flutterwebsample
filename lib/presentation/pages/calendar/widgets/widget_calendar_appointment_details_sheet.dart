/* import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_phone_dialcode_parser.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/bloc_appointment_list/appointment_list_bloc.dart';
import 'package:allbert_cms/presentation/popups/popup_customer_details.dart';
import 'package:allbert_cms/presentation/providers/provider_appointment_details.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_nullable_entity_text.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/utils/application_entity_text_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

typedef OnDeleteAppointment = Function(String);

class AppointmentDetailsSheet extends StatefulWidget {
  AppointmentDetailsSheet({
    Key key,
    @required this.onClose,
    @required this.onDeleteAppointment,
  }) : super(key: key);

  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();
  final PhoneDialcodeParser dialcodeParser = PhoneDialcodeParser();
  final ApplicationEntityTextReader applicationEntityTextReader =
      ApplicationEntityTextReader();
  final ApplicationNullableEntityTextFactory nullableEntityTextFactory =
      ApplicationNullableEntityTextFactory();

  final VoidCallback onClose;

  final OnDeleteAppointment onDeleteAppointment;

  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _AppointmentDetailsSheetState createState() =>
      _AppointmentDetailsSheetState();
}

class _AppointmentDetailsSheetState extends State<AppointmentDetailsSheet> {
  bool _isDeleting;

  @override
  void initState() {
    super.initState();

    _isDeleting = false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentDetailsProvider>(context);
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: defaultShadowBlurRadius,
            spreadRadius: defaultShadowSpreadRadius,
            color: lightGrey.withAlpha(defaultShadowAlpha),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: defaultPadding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              SystemLang.LANG_MAP[SystemText.APPOINTMENT_DETAILS]
                  [langIso639Code],
              style: headerStyle_2_bold,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        SystemLang.LANG_MAP[SystemText.DATE][langIso639Code],
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      startDateContainer(context),
                    ],
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        SystemLang.LANG_MAP[SystemText.TIMEOFDAY]
                            [langIso639Code],
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      startTimeContainer(context),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              SystemLang.LANG_MAP[SystemText.EMPLOYEE][langIso639Code],
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 4,
            ),
            employeeContainer(context),
            SizedBox(
              height: 4,
            ),
            Text(
              SystemLang.LANG_MAP[SystemText.SERVICE][langIso639Code],
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 4,
            ),
            serviceContainer(
              context,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              SystemLang.LANG_MAP[SystemText.CUSTOMER][langIso639Code],
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 4,
            ),
            customerContainer(
              context,
            ),
            Spacer(),
            ApplicationContainerButton(
              disabledColor: _isDeleting ? themeColors[ThemeColor.blue] : null,
              label: SystemLang.LANG_MAP[SystemText.DELETE_APPOINTMENT]
                  [langIso639Code],
              disabled: _isDeleting ||
                  provider.selectedAppointmentContainer.appointment.startDate
                      .isBefore(DateTime.now()),
              loadingOnDisabled: _isDeleting,
              color: themeColors[ThemeColor.blue],
              onPress: () async {
                if (!_isDeleting) {
                  await deleteAppointmentAsync();
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            ApplicationContainerButton(
              label: SystemLang.LANG_MAP[SystemText.CLOSE][langIso639Code],
              color: themeColors[ThemeColor.pinkRed],
              onPress: () {
                if (!_isDeleting) {
                  widget.onClose();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void deleteAppointmentAsync() async {
    setState(() {
      _isDeleting = true;
    });
    final appointmentId =
        Provider.of<AppointmentDetailsProvider>(context, listen: false)
            .selectedAppointmentContainer
            .appointment
            .id;
    try {
      await widget.dataSource.updateAppointmentStatusAsync(
          appointmentId: appointmentId,
          status: AppointmentStatus.DeletedByBusiness);
      widget.onDeleteAppointment(appointmentId);
      BlocProvider.of<AppointmentListBloc>(context, listen: false)
          .add(ResetAppointmentListEvent());
      // widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isDeleting = false;
    });
  }

  double toDuration(TimeOfDay t) => t.hour + t.minute / 60.0;

  Widget startTimeContainer(BuildContext context) {
    final container =
        Provider.of<AppointmentDetailsProvider>(context, listen: false)
            .selectedAppointmentContainer;
    final time = TimeOfDay.fromDateTime(container.appointment.startDate);
    return Container(
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(4),
        //border: getStartTimePickerBorderColor(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          time == null
              ? "--nincs megadva--"
              : widget.translateTime.fromTime(time: time),
          style: time == null ? bodyStyle_2_grey : bodyStyle_2,
        ),
      ),
    );
  }

  Widget startDateContainer(BuildContext context) {
    final container =
        Provider.of<AppointmentDetailsProvider>(context, listen: false)
            .selectedAppointmentContainer;
    return Container(
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(4),
        //border: getStartTimePickerBorderColor(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          container == null
              ? "--nincs megadva--"
              : widget.translateDate(date: container.appointment.startDate),
          style: container == null ? bodyStyle_2_grey : bodyStyle_2,
        ),
      ),
    );
  }

  Widget employeeContainer(BuildContext context) {
    final container =
        Provider.of<AppointmentDetailsProvider>(context, listen: false)
            .selectedAppointmentContainer;
    return Container(
        decoration: BoxDecoration(
          color: themeColors[ThemeColor.hollowGrey],
          borderRadius: BorderRadius.circular(4),
        ),
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ApplicationAvatarImage(
                  image: container.employee.avatar,
                  size: 25,
                  //color: e.info.color,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  widget.applicationEntityTextReader
                      .employeeName(context, container.employee),
                  style: widget.nullableEntityTextFactory
                      .getTextStyle(container.employee),
                ),
              ],
            ),
          ),
        ));
  }

  Widget serviceContainer(BuildContext context) {
    final container =
        Provider.of<AppointmentDetailsProvider>(context, listen: false)
            .selectedAppointmentContainer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            decoration: BoxDecoration(
              color: themeColors[ThemeColor.hollowGrey],
              borderRadius: BorderRadius.circular(4),
            ),
            child: SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      widget.applicationEntityTextReader
                          .serviceName(context, container.appointment.service),
                      style: widget.nullableEntityTextFactory
                          .getTextStyle(container.appointment.service),
                    ),
                  ],
                ),
              ),
            )),
        //getServicePickerWarningText(services),
      ],
    );
  }

  Widget customerContainer(BuildContext context) {
    final container =
        Provider.of<AppointmentDetailsProvider>(context, listen: false)
            .selectedAppointmentContainer;
    return Container(
      decoration: BoxDecoration(
        color: themeColors[ThemeColor.hollowGrey],
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApplicationTextButton(
                label: widget.applicationEntityTextReader
                    .customerName(context, container.appointment.customer),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomerDetailsPopup(
                        customerId: container.appointment.customerId,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */