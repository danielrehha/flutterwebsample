import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';

import 'application_state_object_handler.dart';
import 'application_text_button.dart';

typedef OnServiceSelected = Function(List<Service>);

class ApplicationEmployeeSelector extends StatefulWidget {
  ApplicationEmployeeSelector({
    Key key,
    this.onServiceSelected,
  }) : super(key: key);

  final OnServiceSelected onServiceSelected;
  final IApiDataSource apiDataSource = ApiDataSource();
  final PersonNameResolver nameResolver = PersonNameResolver();

  @override
  State<ApplicationEmployeeSelector> createState() =>
      _ApplicationEmployeeSelectorState();
}

class _ApplicationEmployeeSelectorState
    extends State<ApplicationEmployeeSelector> {
  bool _isLoading;
  String _errorMessage;
  List<Service> _services;
  List<Service> _selectedServices;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _services = [];

    _selectedServices = [];

    _loadAsync();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 150),
      child: ApplicationStateObjectHandler(
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          stateObject: ApplicationTextButton(
              onPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return MultiSelectDialog(
                        initialValue: _selectedServices.isEmpty
                            ? []
                            : _services
                                .where((element) =>
                                    _selectedServices.contains(element.id))
                                .toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          _selectedServices.clear();
                          for (var val in values ?? []) {
                            _selectedServices.add((val as Service));
                          }
                          setState(() {});
                          widget.onServiceSelected(_selectedServices);
                        },
                        items: _services
                            .map(
                              (e) => MultiSelectItem(
                                e,
                                e.name,
                              ),
                            )
                            .toList(),
                      );
                    });
              },
              label: _selectedServices == null || _selectedServices.isEmpty
                  ? "kiválasztás"
                  : "${_selectedServices.length} szolgáltatás kiválasztva")),
    );
  }

  Future<void> _loadAsync() async {
    setState(() {
      _isLoading = true;
    });

    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;

    try {
      _services = await widget.apiDataSource
          .getServiceListAsync(businessId: businessId);
      _selectedServices = [];
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    setState(() {
      _isLoading = false;
    });
  }
}