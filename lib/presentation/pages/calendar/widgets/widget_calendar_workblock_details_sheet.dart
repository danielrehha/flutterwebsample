/* import 'package:allbert_cms/domain/entities/entity_containers/et_booking_container.dart';
import 'package:allbert_cms/presentation/shared/application_nullable_entity_text.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/utils/application_entity_text_reader.dart';
import 'package:flutter/material.dart';
import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_avatar_image.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../theme_calendar.dart';

typedef OnDeleteWorkblock = Function(String);

class WorkblockDetailsSheet extends StatefulWidget {
  WorkblockDetailsSheet({
    Key key,
    @required this.onDeleteWorkblock,
    @required this.onClose,
  }) : super(key: key);

  final OnDeleteWorkblock onDeleteWorkblock;
  final VoidCallback onClose;
  final ApplicationNullableEntityTextFactory nullableEntityTextFactory =
      ApplicationNullableEntityTextFactory();
  final ApplicationEntityTextReader entityTextReader =
      ApplicationEntityTextReader();

  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();
  final PersonNameResolver nameResolver = PersonNameResolver();
  final SnackBarActions snackBarActions = SnackBarActions();
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _WorkblockDetailsSheetState createState() => _WorkblockDetailsSheetState();
}

class _WorkblockDetailsSheetState extends State<WorkblockDetailsSheet> {
  bool _isDeleting;
  String _errorMessage;

  TextEditingController _durationController;
  TextEditingController _descriptionController;

  CalendarCellContainer _container;

  @override
  void initState() {
    super.initState();
    _isDeleting = false;

    _durationController = TextEditingController();
    _descriptionController = TextEditingController();

    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    final container = Provider.of<AppointmentDetailsProvider>(context)
        .selectedWorkblockContainer;
    final provider = Provider.of<CalendarProvider>(context);
    _durationController.text = container.workBlock.endTime
        .difference(container.workBlock.startTime)
        .inMinutes
        .toString();
    _descriptionController.text = container.workBlock.description;
    return Container(
      width: calendarSheetWidth,
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
              SystemLang.LANG_MAP[SystemText.WORKBLOCK_DETAILS][langIso639Code],
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
                      Text(
                        widget.translateDate(
                            date: container.workBlock.startTime),
                      ),
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
                      Text(
                        widget.translateTime(
                            time: container.workBlock.startTime),
                      ),
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
            employeeContainer(context, container),
            SizedBox(
              height: 4,
            ),
            Text(
              SystemLang.LANG_MAP[SystemText.SERVICE_DURATION][langIso639Code],
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 4,
            ),
            ApplicationTextField(
              onChanged: (value) {
                Provider.of<CalendarProvider>(context, listen: false)
                    .updateWorkBlockDuration(int.parse(value));
              },
              topPadding: 0,
              controller: _durationController,
              readOnly: true,
              actionChild:
                  Text(SystemLang.LANG_MAP[SystemText.MINUTES][langIso639Code]),
              filters: [FilteringTextInputFormatter.digitsOnly],
            ),
            provider.workBlockDuration < 15 || provider.workBlockDuration > 120
                ? Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        SystemLang.LANG_MAP[SystemText
                            .CREATE_WORKBLOCK_MINUTES_ERROR][langIso639Code],
                        style:
                            TextStyle(color: themeColors[ThemeColor.pinkRed]),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 4,
            ),
            Text(
              SystemLang.LANG_MAP[SystemText.BUSINESS_DESCRIPTION]
                  [langIso639Code],
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 80,
              child: ApplicationTextField(
                hintText:
                    SystemLang.LANG_MAP[SystemText.WORKBLOCK_DESCRIPTION_HINT]
                        [langIso639Code],
                topPadding: 0,
                textAlignVertical: TextAlignVertical.top,
                controller: _descriptionController,
                readOnly: true,
                keyboardType: TextInputType.multiline,
                maxLength: 70,
                maxLines: null,
                //showLength: true,
                canBeEmpty: false,
                expands: true,
              ),
            ),
            Spacer(),
            Text(
              _errorMessage,
              style: TextStyle(
                color: themeColors[ThemeColor.pinkRed],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ApplicationContainerButton(
              disabledColor: themeColors[ThemeColor.blue],
              label: SystemLang.LANG_MAP[SystemText.DELETE_WORKBLOCK]
                  [langIso639Code],
              disabled: !canDelete(context),
              loadingOnDisabled: _isDeleting,
              color: themeColors[ThemeColor.blue],
              onPress: () async {
                if (canDelete(context)) {
                  await deleteWorkblockAsync(context, container);
                } else {
                  setState(() {});
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

/*   bool canUpdate(BuildContext context) {
    final provider = Provider.of<CalendarSheetProvider>(context, listen: false);
    if (provider.workBlockDuration < 15 || provider.workBlockDuration > 120) {
      return false;
    }
    if (_isUpdating || _isDeleting) {
      return false;
    }
    return true;
  } */

  bool canDelete(BuildContext context) {
    if (_isDeleting) {
      return false;
    }
    return true;
  }

  Future<void> deleteWorkblockAsync(
      BuildContext context, CalendarCellContainer container) async {
    setState(() {
      _isDeleting = true;
    });

    String _errorMessage = "";

    try {
      await widget.dataSource.deleteWorkBlockAsync(
        employeeId: container.employee.id,
        workBlockId: container.workBlock.id,
      );
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    if (_errorMessage.isEmpty) {
      widget.onDeleteWorkblock(container.workBlock.id);
    }

    setState(() {
      _isDeleting = false;
    });
  }

  Widget employeeContainer(
      BuildContext context, CalendarCellContainer container) {
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
                  image: container.employee == null
                      ? null
                      : container.employee.avatar,
                  size: 25,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  widget.entityTextReader
                      .employeeName(context, container.employee),
                  style: widget.nullableEntityTextFactory
                      .getTextStyle(container.employee),
                ),
              ],
            ),
          ),
        ));
  }
}
 */