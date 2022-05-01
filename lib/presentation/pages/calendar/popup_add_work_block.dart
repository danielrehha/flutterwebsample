import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_employee_work_block.dart';
import 'package:allbert_cms/presentation/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:allbert_cms/presentation/shared/application_container_button.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddWorkBlockPopup extends StatefulWidget {
  AddWorkBlockPopup({Key key, @required this.employeeId}) : super(key: key);

  final String employeeId;
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _AddWorkBlockPopupState createState() => _AddWorkBlockPopupState();
}

class _AddWorkBlockPopupState extends State<AddWorkBlockPopup> {
  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: UnconstrainedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  child: ApplicationContainerButton(
                    label: "Add block",
                    disabled: _isLoading,
                    loadingOnDisabled: true,
                    color: themeColors[ThemeColor.blue],
                    disabledColor: themeColors[ThemeColor.blue],
                    onPress: () async {
                      await createWorkBlockAsync();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createWorkBlockAsync() async {
    setState(() {
      _isLoading = true;
    });

    String _errorMessage = "";

    try {
      final now = DateTime.now();
      final workBlock = EmployeeWorkBlockModel(
        id: Uuid().v4(),
        employeeId: widget.employeeId,
        startTime: DateTime(now.year, now.month, now.day, 15),
        endTime: DateTime(now.year, now.month, now.day, 15)
            .add(Duration(minutes: 30)),
        description: "pause",
      );
      await widget.dataSource.createWorkBlockAsync(
        employeeId: widget.employeeId,
        workBlock: workBlock,
      );
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    if (_errorMessage.isEmpty) {
      BlocProvider.of<CalendarBloc>(context, listen: false)
          .add(ResetCalendarEvent());
    }

    setState(() {
      _isLoading = false;
    });
  }
}
