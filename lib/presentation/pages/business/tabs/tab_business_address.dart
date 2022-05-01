import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/utils/util_country_name_resolver.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/data/models/model_business_address.dart';
import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:allbert_cms/presentation/actions/actions_snackbar.dart';
import 'package:allbert_cms/presentation/popups/popup_select_city.dart';
import 'package:allbert_cms/presentation/popups/popup_select_country.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BusinessAddressTab extends StatefulWidget {
  BusinessAddressTab({Key key}) : super(key: key);

  final SnackBarActions snackBarActions = SnackBarActions();
  final ApiDataSource dataSource = ApiDataSource();
  final CountryNameResolver countryNameResolver = CountryNameResolver();

  @override
  _BusinessAddressTabState createState() => _BusinessAddressTabState();
}

class _BusinessAddressTabState extends State<BusinessAddressTab> {
  TextEditingController countryController = TextEditingController();

  TextEditingController countyController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  Country selectedCountry;

  String contactAlpha2Code;

  String selectedCity;

  TextEditingController zipController = TextEditingController();

  TextEditingController streetNameController = TextEditingController();

  TextEditingController streetTypeController = TextEditingController();

  TextEditingController streetNumberController = TextEditingController();

  TextEditingController addressDescriptionController = TextEditingController();

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    updateInfo();

    _isLoading = false;
  }

  void updateInfo() {
    final address =
        Provider.of<BusinessProvider>(context, listen: false).business.address;

    selectedCountry = Country(
      name: address.countryName,
      nativeName: address.countryNativeName,
      alpha2Code: address.countryAlpha2Code,
    );

    countryController.text =
        widget.countryNameResolver.getCountryName(selectedCountry);
    cityController.text = address.cityName;
    zipController.text = address.zipCode;
    streetNameController.text = address.streetName;
    streetTypeController.text = address.streetType;
    streetNumberController.text = address.streetNumber;

    addressDescriptionController.text = address.description;
  }

  bool validateFields() {
    bool error = false;
    String errorMessage = "cannot be empty.";
    String fieldName = "field";
    if (countryController.text.isEmpty) {
      error = true;
      fieldName = "Country";
    }
    if (cityController.text.isEmpty) {
      error = true;
      fieldName = "City";
    }
    if (zipController.text.isEmpty) {
      error = true;
      fieldName = "Zip code";
    }
    if (streetNameController.text.isEmpty) {
      error = true;
      fieldName = "Street name";
    }
    if (streetTypeController.text.isEmpty) {
      error = true;
      fieldName = "Street type";
    }
    if (streetNumberController.text.isEmpty) {
      error = true;
      fieldName = "Street number";
    }
    if (error) {
      widget.snackBarActions
          .dispatchErrorSnackBar(context, message: "$fieldName $errorMessage");
    }
    return !error;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et quam finibus, commodo diam ac, bibendum nunc.",
            style: bodyStyle_2_grey,
          ),
          SizedBox(
            height: 30,
          ),
          Text('Ország *'),
          ApplicationTextField(
            controller: countryController,
            textAlign: TextAlign.start,
            readOnly: true,
            hintText: "Válasszon",
            actionChild: InkWell(
              child: Icon(Icons.arrow_drop_down),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SelectCountryPopup(selectCountryCallback: (value) {
                        if (value.name != selectedCountry.name) {
                          setState(() {
                            selectedCountry = value;
                            countryController.text = widget.countryNameResolver
                                .getCountryName(value);
                            selectedCity = null;
                            cityController.text = null;
                          });
                        }
                      });
                    });
              },
            ),
          ),
          Text('Város *'),
          ApplicationTextField(
            controller: cityController,
            textAlign: TextAlign.start,
            hintText:
                selectedCountry == null ? "Válasszon országot" : "Válasszon",
            readOnly: true,
            actionChild: InkWell(
              child: Icon(Icons.arrow_drop_down),
              onTap: () {
                setState(() {
                  selectedCity = null;
                  cityController.text = null;
                });
                if (selectedCountry != null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SelectCityPopup(
                          countryCode: selectedCountry.alpha2Code,
                          selectCityCallback: (value) {
                            setState(() {
                              selectedCity = value;
                              cityController.text = value;
                            });
                          },
                        );
                      });
                }
              },
            ),
          ),
          Text('Irányítószám *'),
          ApplicationTextField(
            controller: zipController,
            textAlign: TextAlign.start,
            filters: [FilteringTextInputFormatter.digitsOnly],
          ),
          Text('Közterület neve *'),
          ApplicationTextField(
            controller: streetNameController,
            textAlign: TextAlign.start,
          ),
          Text('Közterület jellege *'),
          ApplicationTextField(
            controller: streetTypeController,
            textAlign: TextAlign.start,
            hintText: 'út, utca, tér, ..',
          ),
          Text('Házszám *'),
          ApplicationTextField(
            controller: streetNumberController,
            textAlign: TextAlign.start,
            filters: [FilteringTextInputFormatter.digitsOnly],
          ),
          Text('További leírás'),
          ApplicationTextField(
            controller: addressDescriptionController,
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 20,
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
                    await saveAddressAsync();
                  }
                },
                color: Colors.black,
              ),
            ],
          )
        ],
      ),
    );
  }

  void saveAddressAsync() async {
    setState(() {
      _isLoading = true;
    });
    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;
    final address = BusinessAddressModel(
      businessId: businessId,
      countryName: selectedCountry.name,
      countryNativeName: selectedCountry.nativeName ?? null,
      countryAlpha2Code: selectedCountry.alpha2Code,
      cityName: selectedCity,
      zipCode: zipController.text,
      streetName: streetNameController.text,
      streetType: streetTypeController.text,
      streetNumber: streetNumberController.text,
      description: addressDescriptionController.text,
    );
    try {
      await widget.dataSource
          .updateBusinessAddressAsync(businessId: businessId, address: address);
      Provider.of<BusinessProvider>(context, listen: false).update(
          business: Provider.of<BusinessProvider>(context, listen: false)
              .business
              .copyWith(address: address));
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
