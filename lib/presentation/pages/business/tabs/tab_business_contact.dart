import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/utils/util_phone_number_validator.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_business_contact.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/shared/widget_phone_number_field.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessContactTab extends StatefulWidget {
  BusinessContactTab({Key key}) : super(key: key);

  final SnackBarActions snackBarActions = SnackBarActions();
  final ApiDataSource dataSource = ApiDataSource();
  final PhoneNumberValidator phoneNumberValidator = PhoneNumberValidator();

  @override
  _BusinessContactTabState createState() => _BusinessContactTabState();
}

class _BusinessContactTabState extends State<BusinessContactTab> {
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  String selectedPhoneIsoCode;

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    updateInfo();

    _isLoading = false;
  }

  bool validateFields() {
    bool error = false;
    String fieldName = "Field";
    String errorMessage = "cannot be empty.";
    if (firstNameController.text.isEmpty) {
      error = true;
      fieldName = "First name";
    }
    if (lastNameController.text.isEmpty) {
      error = true;
      fieldName = "Last name";
    }
    if (phoneController.text.isNotEmpty &&
        !widget.phoneNumberValidator.validateWithIso(
            countryCode: selectedPhoneIsoCode,
            phoneNumber: phoneController.text)) {
      error = true;
      fieldName = "Phone number";
      errorMessage = "is not valid";
    }
    if (phoneController.text.isEmpty) {
      error = true;
      fieldName = "Phone number";
      errorMessage = "cannot be empty.";
    }
    if (emailController.text.isNotEmpty &&
        !EmailValidator.validate(emailController.text)) {
      error = true;
      fieldName = "Email address";
      errorMessage = "is not valid";
    }
    if (emailController.text.isEmpty) {
      error = true;
      fieldName = "Email address";
      errorMessage = "cannot be empty.";
    }
    if (error) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: "$fieldName $errorMessage");
    }
    return !error;
  }

  void updateInfo() {
    final contact =
        Provider.of<BusinessProvider>(context, listen: false).business.contact;

    firstNameController.text = contact.firstName;
    lastNameController.text = contact.lastName;
    phoneController.text = contact.phone;
    emailController.text = contact.email;
    selectedPhoneIsoCode = contact.phoneIso;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.orange,
      height: 600,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "A kapcsolattartó az a személy, akivel a felhasználók a megadott elérhetőségeken keresztül kapcsolatba léphetnek.",
              style: bodyStyle_2_grey,
            ),
            SizedBox(
              height: 30,
            ),
            Text("Keresztnév"),
            /* Text(
              "Kapcsolattartó keresztneve",
              style: bodyStyle_2_grey,
            ), */
            ApplicationTextField(
              controller: firstNameController,
              maxLength: 20,
            ),
            Text("Vezetéknév"),
            /* Text(
              "Kapcsolattartó vezetékneve",
              style: bodyStyle_2_grey,
            ), */
            ApplicationTextField(
              controller: lastNameController,
              maxLength: 20,
            ),
            Text("E-mail cím"),
            Text(
              "Kapcsolattartó e-mail címe, amely az Allbert mobilalkalmazáson keresztül elérhető a felhasználók számára",
              style: bodyStyle_2_grey,
            ),
            ApplicationTextField(
              controller: emailController,
              maxLength: 40,
            ),
            Text("Telefonszám"),
            Text(
              "Kapcsolattartó telefonszáma, amely az Allbert mobilalkalmazáson keresztül elérhető a felhasználók számára",
              style: bodyStyle_2_grey,
            ),
            PhoneNumberField(
              selectedPhoneIsoCode: selectedPhoneIsoCode,
              controller: phoneController,
              countryCodeCallback: (value) {
                selectedPhoneIsoCode = value;
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ApplicationTextButton(
                  label: "Változtatások mentése",
                  fontWeight: FontWeight.bold,
                  disabled: _isLoading,
                  onPress: () async {
                    if (validateFields()) {
                      await saveInfoAsync();
                    }
                  },
                  color: Colors.black,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void saveInfoAsync() async {
    setState(() {
      _isLoading = true;
    });
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;
    final contact = BusinessContactModel(
      businessId: businessId,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
      phoneIso: selectedPhoneIsoCode,
      email: emailController.text,
    );
    try {
      await widget.dataSource
          .updateBusinessContactAsync(businessId: businessId, contact: contact);
      Provider.of<BusinessProvider>(context, listen: false).update(
          business: Provider.of<BusinessProvider>(context, listen: false)
              .business
              .copyWith(contact: contact));
      updateInfo();
      widget.snackBarActions.dispatchSuccessSnackBar(context);
    } on ServerException catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.message);
    } on Exception catch (e) {
      widget.snackBarActions.dispatchErrorSnackBar(context, err: e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
