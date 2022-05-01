import 'package:allbert_cms/core/utils/util_country_name_resolver.dart';
import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:allbert_cms/presentation/bloc/bloc_city_list/city_list_bloc.dart';
import 'package:allbert_cms/presentation/bloc/bloc_country_list/country_list_bloc.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/shared/application_loading_swap_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_text_field.dart';
import 'package:allbert_cms/presentation/themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hovering/hovering.dart';

typedef SelectCityCallback = Function(String);

class SelectCityPopup extends StatefulWidget {
  SelectCityPopup(
      {Key key, @required this.selectCityCallback, @required this.countryCode})
      : super(key: key);

  final String countryCode;
  final SelectCityCallback selectCityCallback;

  @override
  _SelectCityPopupState createState() => _SelectCityPopupState();
}

class _SelectCityPopupState extends State<SelectCityPopup> {
  TextEditingController searchController;

  bool _isLoading;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    BlocProvider.of<CityListBloc>(context, listen: false)
        .add(ResetCityListEvent());

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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Város kiválasztása',
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
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ApplicationLoadingSwapButton(
                    isLoading: _isLoading,
                    button: ApplicationTextButton(
                      label: "Keresés",
                      onPress: () {
                        if (searchController.text.isNotEmpty) {
                          BlocProvider.of<CityListBloc>(context).add(
                              FetchCityListEvent(
                                  countryCode: widget.countryCode,
                                  queryString: searchController.text));
                        }
                      },
                    ),
                  ),
                ],
              ),
              BlocBuilder<CityListBloc, CityListState>(
                builder: (context, state) {
                  if (state is CityListInitial) {
                    BlocProvider.of<CityListBloc>(context).add(
                        FetchCityListEvent(
                            countryCode: widget.countryCode,
                            queryString: "Budapest"));
                  }
                  if (state is CityListLoaded) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: buildCityList(
                          cities: state.cities,
                        ),
                      ),
                    );
                  }
                  if (state is CityListError) {
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
            ],
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

  Widget buildCityList({@required List<String> cities}) {
    if (cities != null && cities.isNotEmpty) {
      return ListView.builder(
        itemCount: cities.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: HoverWidget(
                onHover: (value) {},
                hoverChild: Text(
                  cities[index],
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                child: Text(
                  cities[index],
                ),
              ),
            ),
            onTap: () {
              widget.selectCityCallback(
                cities[index],
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
