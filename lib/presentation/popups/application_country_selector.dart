import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:allbert_cms/presentation/bloc/bloc_country_list/country_list_bloc.dart';
import 'package:allbert_cms/presentation/shared/application_loading_circle.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

typedef OnCountrySelectCallback = Function(Country);

class CountrySelectorPopup extends StatefulWidget {
  CountrySelectorPopup({Key key, @required this.onSelect}) : super(key: key);

  OnCountrySelectCallback onSelect;

  @override
  _CountrySelectorPopupState createState() => _CountrySelectorPopupState();
}

class _CountrySelectorPopupState extends State<CountrySelectorPopup> {
  String searchText;

  void search(String args) {
    setState(() {
      searchText = args;
    });
  }

  List<Country> filterCountryList(List<Country> countries, String args) {
    if (args == null || args.isEmpty) {
      return countries;
    }
    return countries
        .where((element) =>
            element.name.toLowerCase().contains(args.toLowerCase()) ||
            element.nativeName.toLowerCase().contains(args.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(AntDesign.search1),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Keresés...",
                    ),
                    onChanged: search,
                  ),
                )
              ],
            ),
            Expanded(
              child: BlocConsumer<CountryListBloc, CountryListState>(
                listener: (context, state) {
                  if (state is CountryListLoaded) {}
                },
                builder: (context, state) {
                  if (state is CountryListInitial) {
                    BlocProvider.of<CountryListBloc>(context)
                        .add(FetchCountryListEvent());
                  }
                  if (state is CountryListLoaded) {
                    return buildCountryList(
                        filterCountryList(state.countries, searchText));
                  }
                  if (state is CountryListError) {
                    return Text(
                      state.failure.errorMessage,
                      style: bodyStyle_1_grey,
                    );
                  }
                  return ApplicationLoadingIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCountryList(List<Country> countries) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: countries.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Text(
                "${countries[index].name} / ${countries[index].nativeName}"),
            onTap: () {
              widget.onSelect(countries[index]);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
