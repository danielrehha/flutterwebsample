import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:meta/meta.dart';

abstract class ILocationDataSource {
  Future<List<Country>> loadCountryListAsync();
  Future<List<String>> loadCityListAsync({@required String countryCode, String queryString});
}
