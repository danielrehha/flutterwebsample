import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_phone_dialcode_parser.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_details.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_rating_indicator.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';

import '../themes/theme_size.dart';

class CustomerDetailsPopup extends StatefulWidget {
  CustomerDetailsPopup({Key key, @required this.customerId}) : super(key: key);

  final String customerId;

  @override
  _CustomerDetailsPopupState createState() => _CustomerDetailsPopupState();
}

class _CustomerDetailsPopupState extends State<CustomerDetailsPopup> {
  final TranslateDate translateDate = TranslateDate();

  final PersonNameResolver nameResolver = PersonNameResolver();
  final ApiDataSource dataSource = ApiDataSource();
  final PhoneDialcodeParser dialcodeParser = PhoneDialcodeParser();

  CustomerDetailsDto dto;
  String errorMessage = "";
  bool isLoading;
  bool isError;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    isError = false;

    loadCustomerAsync();
  }

  void loadCustomerAsync() async {
    try {
      final result = await dataSource.getCustomerDetailsAsync(
          customerId: widget.customerId);
      setState(() {
        isLoading = false;
        isError = false;
        dto = result;
      });
    } on Exception catch (e) {
      print(e.toString());
      errorMessage = e.toString();
      setState(() {
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: defaultPadding,
        child: Container(
            width: 450,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: getCurrentStateContent()),
      ),
    );
  }

  Widget getCurrentStateContent() {
    if (isError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Szerver hiba",
            style: headerStyle_3_bold,
          ),
          Text(errorMessage),
        ],
      );
    }
    if (!isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vendég neve",
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.start,
                ),
                Text(
                  nameResolver.cultureBasedResolve(
                      firstName: dto.customer.info.firstName,
                      lastName: dto.customer.info.lastName),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Összes foglalás",
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.start,
                ),
                Text(
                  dto.totalAppointmentCount.toString(),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nem teljesített foglalások",
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.start,
                ),
                Text(
                  dto.uncompletedAppointmentCount.toString(),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Látogatási mutató",
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    ApplicationRatingIndicator(
                        avgRating: dto.appointmentCompletionIndex, size: 12),
                    SizedBox(
                      width: 4,
                    ),
                    Text("(${dto.appointmentCompletionIndex.toString()})"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Regisztráció dátuma",
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.start,
                ),
                Text(
                  translateDate(date: dto.customer.createdOn),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Telefonszám",
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.start,
                ),
                Text(
                  "${dto.customer.info.phone}",
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "E-mail cím",
                  style: bodyStyle_2_grey,
                  textAlign: TextAlign.start,
                ),
                Text(
                  "${dto.customer.info.email}",
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          )
        ],
      );
    }
    return Center(
      child: ApplicationLoadingIndicator(),
    );
  }
}
