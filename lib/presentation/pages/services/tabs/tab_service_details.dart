import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/pages/services/utils_service.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

typedef OnUpdateService = Function(Service);

class ServiceDetailsTab extends StatefulWidget {
  ServiceDetailsTab({Key key, @required this.service, @required this.onUpdate})
      : super(key: key);

  final Service service;
  final OnUpdateService onUpdate;

  final IApiDataSource dataSource = ApiDataSource();

  final ServiceUtils serviceUtils = ServiceUtils();
  final SnackBarActions snackBarActions = SnackBarActions();

  @override
  _ServiceDetailsTabState createState() => _ServiceDetailsTabState();
}

class _ServiceDetailsTabState extends State<ServiceDetailsTab> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _durationController = TextEditingController();

  String _selectedCurrency = 'HUF';

  List<String> _availableCurrencies = [
    'HUF',
    'EUR',
    'USD',
  ];

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    _nameController.text = widget.service.name;
    _costController.text = widget.service.cost.toString();
    _durationController.text = widget.service.duration.toString();
    _selectedCurrency = widget.service.currency;
  }

  @override
  Widget build(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    return Container(
      width: defaultColumnWidth,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
              '${SystemLang.LANG_MAP[SystemText.SERVICE_NAME][langIso639Code]}\*'),
          ApplicationTextField(
            bottomPadding: 20,
            controller: _nameController,
          ),
          Text(
              '${SystemLang.LANG_MAP[SystemText.SERVICE_DURATION][langIso639Code]}\*'),
          ApplicationTextField(
            bottomPadding: 20,
            controller: _durationController,
            actionChild:
                Text(SystemLang.LANG_MAP[SystemText.MINUTES][langIso639Code]),
          ),
          Text(
              '${SystemLang.LANG_MAP[SystemText.SERVICE_COST][langIso639Code]}\*'),
          ApplicationWidgetContainer(
            height: 50,
            verticalInnerPadding: 0,
            horizontalPadding: 0,
            horizontalInnerPadding: 0,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: ApplicationTextField(
                        topPadding: 0,
                        showShadow: false,
                        controller: _costController,
                        maxLength: 40,
                        filters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ),
                  Container(
                    child: DropdownButton(
                      underline: SizedBox(),
                      value: _selectedCurrency,
                      onChanged: (value) {
                        if (_selectedCurrency != value) {
                          setState(() {
                            _selectedCurrency = value;
                          });
                        }
                      },
                      items: _availableCurrencies.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ApplicationContainerButton(
            loadingOnDisabled: true,
            disabledColor: themeColors[ThemeColor.blue],
            disabled: _isLoading,
            label: SystemLang.LANG_MAP[SystemText.SAVE][langIso639Code],
            color: themeColors[ThemeColor.blue],
            onPress: () async {
              if (widget.serviceUtils.isInfoValid(
                context,
                name: _nameController.text,
                cost: _costController.text,
                duration: _durationController.text,
              )) {
                await updateServiceAsync(context);
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          ApplicationContainerButton(
            label: SystemLang.LANG_MAP[SystemText.CANCEL][langIso639Code],
            color: themeColors[ThemeColor.pinkRed],
            onPress: () {
              if (!_isLoading) {
                Navigator.of(context).pop();
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Future<void> updateServiceAsync(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    bool error = false;

    try {
      final businessId =
          Provider.of<BusinessProvider>(context, listen: false).businessId;
      final service = ServiceModel(
        id: widget.service.id,
        name: _nameController.text,
        cost: double.parse(_costController.text),
        duration: int.parse(_durationController.text),
        currency: _selectedCurrency,
        businessId: businessId,
        enabled: widget.service.enabled,
        createdOn: widget.service.createdOn,
      );
      await widget.dataSource.updateServiceAsync(service: service);
      widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      error = true;
      widget.snackBarActions.dispatchErrorSnackBar(context, message: e.message);
    } on Exception catch (e) {
      error = true;
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: e.toString());
    }

    setState(() {
      _isLoading = false;
    });

    if (!error) {
      BlocProvider.of<ServicesBloc>(context, listen: false)
          .add(ResetServicesEvent());
    }
  }
}
