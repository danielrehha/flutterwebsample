import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';

class CountryNameResolver {
  String getCountryName(Country country) {
    if (country.nativeName == null) {
      return country.name;
    }
    return "${country.name} / ${country.nativeName}";
  }
}