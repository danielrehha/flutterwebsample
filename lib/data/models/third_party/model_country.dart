import 'package:allbert_cms/domain/entities/third-party/entity_country.dart';
import 'package:meta/meta.dart';

class CountryModel extends Country {
  final String name;
  final String nativeName;
  final String alpha2Code;

  CountryModel({
    @required this.name,
    @required this.nativeName,
    @required this.alpha2Code,
  }) : super(
          name: name,
          nativeName: nativeName,
          alpha2Code: alpha2Code,
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json["name"],
      nativeName: json["nativeName"],
      alpha2Code: json["alpha2Code"],

    );
  }
}
