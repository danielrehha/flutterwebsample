import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/shared/progress_circle.dart';
import 'package:allbert_cms/core/utils/util_empty_field_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';

// ignore: must_be_immutable
class EditServicePopup extends StatefulWidget {
  EditServicePopup({Key key, this.service}) : super(key: key);

  ServiceModel service;

  @override
  _EditServicePopupState createState() => _EditServicePopupState();
}

class _EditServicePopupState extends State<EditServicePopup> {
  TextEditingController nameController = TextEditingController();

  TextEditingController durationController = TextEditingController();

  TextEditingController costController = TextEditingController();

  bool isEdit = false;

  bool nameError = false;

  bool durationError = false;

  bool costError = false;

  String errorMessage = '';

  int maxDuration = 300;

  int minDuration = 15;

  String selectedCurrency = 'HUF';

  List<String> currenciies = [
    'HUF',
    'EUR',
    'USD',
  ];

  EmptyFieldVerification emptyFieldVerification = EmptyFieldVerification();

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      nameController.text = widget.service.name;
      durationController.text = widget.service.duration.toString();
      costController.text = widget.service.cost.toString();
      selectCurrency(widget.service.currency);
      isEdit = true;
    }
  }

  void selectCurrency(String currency) {
    setState(() {
      selectedCurrency = currency;
    });
  }

  void addService() {
    if (fieldVerification()) {
      ServiceModel newService = ServiceModel(
          id: Uuid().v4(),
          name: nameController.text,
          cost: double.parse(costController.text),
          duration: int.parse(durationController.text),
          currency: selectedCurrency,
          businessId:
              Provider.of<BusinessProvider>(context, listen: false).businessId);
      BlocProvider.of<ServicesBloc>(context)
          .add(AddServiceEvent(service: newService));
    } else {
      setState(() {});
    }
  }

  void editService() {
    if (fieldVerification()) {
      ServiceModel updatedService = widget.service.copyWith(
        name: nameController.text,
        cost: double.parse(costController.text),
        duration: int.parse(durationController.text),
        currency: selectedCurrency,
      );
      BlocProvider.of<ServicesBloc>(context)
          .add(EditServiceEvent(service: updatedService));
    } else {
      setState(() {});
    }
  }

  bool fieldVerification() {
    if (!emptyFieldVerification(nameController.text)) {
      nameError = true;
      return false;
    } else {
      nameError = false;
    }
    if (!emptyFieldVerification(durationController.text)) {
      durationError = true;
      return false;
    } else {
      durationError = false;
    }
    if (!emptyFieldVerification(costController.text)) {
      costError = true;
      return false;
    } else {
      costError = false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: defaultPadding,
        child: UnconstrainedBox(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEdit
                      ? 'Szolgáltatás módosítása'
                      : 'Szolgáltatás hozzáadása',
                  style: headerStyle_3_bold,
                ),
                SizedBox(
                  height: paddingBelowHeader,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200, minWidth: 150),
                      child: ApplicationTextField(
                        controller: nameController,
                        error: nameError,
                        hintText: 'pl. hajvágás, konzultáció, ..',
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 70, minWidth: 30),
                      child: ApplicationTextField(
                          controller: durationController,
                          error: durationError,
                          hintText: 'perc',
                          maxLength: 3,
                          textAlign: TextAlign.center,
                          filters: [FilteringTextInputFormatter.digitsOnly]),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 100, minWidth: 60),
                      child: ApplicationTextField(
                          controller: costController,
                          error: costError,
                          hintText: 'ár',
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          filters: [FilteringTextInputFormatter.digitsOnly]),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: themeColors[ThemeColor.hollowGrey],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton(
                        underline: SizedBox(),
                        value: selectedCurrency,
                        onChanged: selectCurrency,
                        items: currenciies.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: paddingBelowHeader,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ApplicationTextButton(
                      label: "Mégse",
                      onPress: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    BlocConsumer<ServicesBloc, ServicesState>(
                      listener: (context, state) {
                        if (state is ServicesLoadedState) {
                          Navigator.pop(context);
                        }
                        if (state is ServicesErrorState) {
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is ServicesAwaitingState) {
                          return ProgressCircle();
                        }
                        return ApplicationTextButton(
                            label:'Mentés',
                          onPress: () {
                            isEdit ? editService() : addService();
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
