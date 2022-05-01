import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/domain/enums/enum_entity_status.dart';
import 'package:allbert_cms/domain/enums/enum_entity_type.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/popups/action_confirmation_popup.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ServiceSettingsTab extends StatefulWidget {
  ServiceSettingsTab({Key key, @required this.service}) : super(key: key);

  final Service service;
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _ServiceSettingsTabState createState() => _ServiceSettingsTabState();
}

class _ServiceSettingsTabState extends State<ServiceSettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: defaultColumnWidth,
      child: settingsContainer(context),
    );
  }

  Widget settingsContainer(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          SystemLang.LANG_MAP[SystemText.OTHER][langIso639Code],
          style: headerStyle_3_bold,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 20,
        ),
        ApplicationTextButton(
          label: widget.service.enabled
              ? SystemLang.LANG_MAP[SystemText.PAUSE_SERVICE][langIso639Code]
              : SystemLang.LANG_MAP[SystemText.ACTIVATE_SERVICE]
                  [langIso639Code],
          onPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return ActionConfirmationPopup(
                  popPageCount: 2,
                  func: () {
                    BlocProvider.of<ServicesBloc>(context)
                        .add(ResetServicesEvent());
                  },
                  asyncOperation: () async {
                    await widget.dataSource.updateEntityStatusAsync(
                      entityId: widget.service.id,
                      entityType: EntityType.Service,
                      status: widget.service.enabled
                          ? EntityStatus.Paused
                          : EntityStatus.Active,
                    );
                  },
                  headerText: widget.service.enabled
                      ? SystemLang.LANG_MAP[SystemText.PAUSE_SERVICE]
                          [langIso639Code]
                      : SystemLang.LANG_MAP[SystemText.ACTIVATE_SERVICE]
                          [langIso639Code],
                  descriptionText:
                      SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
                          [langIso639Code],
                  continueButtonLabel: widget.service.enabled
                      ? SystemLang.LANG_MAP[SystemText.PAUSE][langIso639Code]
                      : SystemLang.LANG_MAP[SystemText.ACTIVATE]
                          [langIso639Code],
                  cancelButtonLabel: SystemLang.LANG_MAP[SystemText.CANCEL]
                      [langIso639Code],
                );
              },
            );
          },
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
              [langIso639Code],
          style: bodyStyle_2_grey,
        ),
        SizedBox(
          height: 10,
        ),
        ApplicationTextButton(
          label: SystemLang.LANG_MAP[SystemText.DELETE_SERVICE][langIso639Code],
          onPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return ActionConfirmationPopup(
                  popPageCount: 2,
                  func: () {
                    BlocProvider.of<ServicesBloc>(context)
                        .add(ResetServicesEvent());
                    BlocProvider.of<EmployeeBloc>(context)
                        .add(ResetEmployeeEvent());
                    BlocProvider.of<CalendarBloc>(context, listen: false)
                        .add(ResetCalendarEvent());
                  },
                  asyncOperation: () async {
                    await widget.dataSource
                        .deleteServiceAsync(serviceId: widget.service.id);
                  },
                  headerText: SystemLang.LANG_MAP[SystemText.DELETE_SERVICE]
                      [langIso639Code],
                  descriptionText:
                      SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
                          [langIso639Code],
                  continueButtonLabel: SystemLang.LANG_MAP[SystemText.DELETE]
                      [langIso639Code],
                  cancelButtonLabel: SystemLang.LANG_MAP[SystemText.CANCEL]
                      [langIso639Code],
                );
              },
            );
          },
          color: themeColors[ThemeColor.pinkRed],
          fontWeight: FontWeight.bold,
        ),
        Text(
          SystemLang.LANG_MAP[SystemText.ADDRESS_DESCRIPTION_HINT]
              [langIso639Code],
          style: bodyStyle_2_grey,
        ),
      ],
    );
  }
}
