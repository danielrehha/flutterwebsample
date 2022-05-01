import 'dart:convert';

import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/contracts/i_datasource_location.dart';
import 'package:allbert_cms/data/endpoints/endpoint_naming_context.dart';
import 'package:allbert_cms/data/models/third_party/model_country.dart';
import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:allbert_cms/data/helpers/crud_request_handler.dart' as parser;
import 'package:meta/meta.dart';

class LocationDataSource implements ILocationDataSource {
  final parser.CrudRequestHandler _handler = parser.CrudRequestHandler();
  final EndpointNamingContext endpoints = EndpointNamingContext();

  @override
  Future<List<Country>> loadCountryListAsync() async {
    final result = await _handler.getRaw(url: endpoints.loadCountryListAsync());
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = jsonDecode(result.data);
    List<Country> countries = [];
    for (var country in body) {
      countries.add(CountryModel.fromJson(country));
    }
    return countries;
  }

  @override
  Future<List<String>> loadCityListAsync(
      {@required String countryCode, String queryString}) async {
    final result = await _handler.getRaw(
        url: endpoints.loadCityListAsync(
            countryCode: countryCode, queryString: queryString));
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final dynList = result.data as List<dynamic>;
    final cityList = dynList.cast<String>();
    return cityList;
  }
}
