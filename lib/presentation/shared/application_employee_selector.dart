import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/dtos/dto_employee_name.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_check_box.dart';
import 'package:allbert_cms/presentation/shared/application_state_object_handler.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

typedef OnEmployeeSelected = Function(List<String>);

class ApplicationEmployeeSelector extends StatefulWidget {
  ApplicationEmployeeSelector({
    Key key,
    this.onEmployeeSelected,
  }) : super(key: key);

  final OnEmployeeSelected onEmployeeSelected;
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
  List<EmployeeNameDto> _employees;
  List<String> _employeeIds;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _employees = [];

    _employeeIds = [];

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
                        initialValue: _employeeIds.isEmpty
                            ? []
                            : _employees
                                .where((element) =>
                                    _employeeIds.contains(element.employeeId))
                                .toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          _employeeIds.clear();
                          for (var val in values ?? []) {
                            _employeeIds.add((val as EmployeeNameDto).employeeId);
                          }
                          setState(() {});
                          widget.onEmployeeSelected(_employeeIds);
                        },
                        items: _employees
                            .map(
                              (e) => MultiSelectItem(
                                e,
                                widget.nameResolver.cultureBasedResolve(
                                    firstName: e.firstName, lastName: e.lastName),
                              ),
                            )
                            .toList(),
                      );
                    });
              },
              label: _employeeIds == null || _employeeIds.isEmpty
                  ? "kiválasztás"
                  : "${_employeeIds.length} alkalmazott kiválasztva")),
    );
  }

  Future<void> _loadAsync() async {
    setState(() {
      _isLoading = true;
    });

    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;

    try {
      _employees = await widget.apiDataSource
          .GetEmployeeNameListAsync(businessId: businessId);
      _employeeIds = [];
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
