import 'package:allbert_cms/core/utils/util_country_name_resolver.dart';
import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:allbert_cms/presentation/bloc/bloc_country_list/country_list_bloc.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hovering/hovering.dart';

typedef SelectCountryCallback = Function(Country);

class SelectCountryPopup extends StatefulWidget {
  SelectCountryPopup({Key key, @required this.selectCountryCallback})
      : super(key: key);

  final SelectCountryCallback selectCountryCallback;
  final CountryNameResolver countryNameResolver = CountryNameResolver();

  @override
  _SelectCountryPopupState createState() => _SelectCountryPopupState();
}

class _SelectCountryPopupState extends State<SelectCountryPopup> {
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
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
          child: BlocBuilder<CountryListBloc, CountryListState>(
            builder: (context, state) {
              if (state is CountryListInitial) {
                BlocProvider.of<CountryListBloc>(context)
                    .add(FetchCountryListEvent());
              }
              if (state is CountryListLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ország kiválasztása',
                          style: headerStyle_3_regular,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ApplicationTextField(
                      controller: searchController,
                      error: false,
                      prefixIcon: Icon(
                        SimpleLineIcons.magnifier,
                        size: 18,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: buildCountryList(
                          countries: filteredCountryList(state.countries),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is CountryListError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.failure.errorMessage),
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ApplicationLoadingIndicator(
                    type: IndicatorType.JumpingDots,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Country> filteredCountryList(List<Country> countries) {
    if (searchController.text.isEmpty) {
      return countries.toList();
    }
    return countries
        .where((e) =>
            e.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            (e.nativeName == null
                ? false
                : e.nativeName
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())))
        .toList();
  }

  Widget buildCountryList({@required List<Country> countries}) {
    if (countries != null && countries.isNotEmpty) {
      return ListView.builder(
        itemCount: countries.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: HoverWidget(
                onHover: (value) {},
                hoverChild: Text(
                  widget.countryNameResolver.getCountryName(countries[index]),
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                child: Text(
                  widget.countryNameResolver.getCountryName(countries[index]),
                ),
              ),
            ),
            onTap: () {
              widget.selectCountryCallback(
                countries[index],
              );
              Navigator.pop(context);
            },
          );
        },
      );
    } else {
      return Text(
        'Nincs találat.',
      );
    }
  }
}
