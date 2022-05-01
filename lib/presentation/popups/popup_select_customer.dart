import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_phone_dialcode_parser.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_customer.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_color.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hovering/hovering.dart';

typedef SelectCustomerCallback = Function(Customer);

class SelectCustomerPopup extends StatefulWidget {
  SelectCustomerPopup({Key key, @required this.onSelectCustomer})
      : super(key: key);

  final SelectCustomerCallback onSelectCustomer;
  final PersonNameResolver nameResolver = PersonNameResolver();
  final PhoneDialcodeParser dialcodeParser = PhoneDialcodeParser();
  final IApiDataSource dataSource = ApiDataSource();

  @override
  _SelectCustomerPopupState createState() => _SelectCustomerPopupState();
}

class _SelectCustomerPopupState extends State<SelectCustomerPopup> {
  bool _isLoading;
  bool _isSearchError;
  String _searchErrorText;
  TextEditingController _searchController;
  List<Customer> _customerList;

  @override
  void initState() {
    super.initState();

    _customerList = [];

    _searchController = TextEditingController();
    _isLoading = false;
    _isSearchError = false;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      child: Padding(
        padding: defaultPadding,
        child: Container(
          width: screenWidth * 0.4,
          height: screenHeight * 0.5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vendég keresése',
                    style: headerStyle_3_regular,
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: ApplicationTextField(
                      controller: _searchController,
                      error: false,
                      hintText:
                          "Keresés név vagy telefonszám (pl. +36301234567) alapján",
                      prefixIcon: Icon(
                        SimpleLineIcons.magnifier,
                        size: 18,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ApplicationTextButton(
                    label: "Keresés",
                    disabled: _isLoading,
                    onPress: () async {
                      if (_searchController.text.isNotEmpty) {
                        await loadCustomerListAsync();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: _isLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ApplicationLoadingIndicator(),
                        ],
                      )
                    : buildCustomerList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadCustomerListAsync() async {
    setState(() {
      _isLoading = true;
      _isSearchError = false;
    });
    try {
      _customerList.clear();
      final result = await widget.dataSource
          .searchCustomerListAsync(customerFlair: _searchController.text);
      if (result.isNotEmpty) {
        setState(() {
          _customerList = result;
        });
      }
    } on ServerException catch (e) {
      _isSearchError = true;
      _searchErrorText = e.message;
    } on Exception catch (e) {
      _isSearchError = true;
      _searchErrorText = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget buildCustomerList() {
    if (_customerList.isEmpty && !_isSearchError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Nincs keresési találat.")],
      );
    }
    if (_isSearchError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(_searchErrorText)],
      );
    }
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _customerList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: customerListView(_customerList[index]),
          );
        },
      ),
    );
  }

  Widget customerListView(Customer customer) {
    return InkWell(
      child: HoverWidget(
        onHover: (event) {},
        hoverChild: Container(
          decoration: BoxDecoration(color: lightGrey),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.nameResolver.cultureBasedResolve(
                      firstName: customer.info.firstName,
                      lastName: customer.info.lastName,
                    ),
                    style: TextStyle(color: themeColors[ThemeColor.blue]),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.dialcodeParser.international(
                      isoCode: customer.info.phoneIso,
                      phoneNumber: customer.info.phone,
                    ),
                    style: TextStyle(color: themeColors[ThemeColor.blue]),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.nameResolver.cultureBasedResolve(
                      firstName: customer.info.firstName,
                      lastName: customer.info.lastName,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.dialcodeParser.international(
                      isoCode: customer.info.phoneIso,
                      phoneNumber: customer.info.phone,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        widget.onSelectCustomer(customer);
        Navigator.of(context).pop();
      },
    );
  }
}
