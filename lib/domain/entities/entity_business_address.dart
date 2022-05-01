import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BusinessAddress extends Equatable {
  final String businessId;
  final String countryName;
  final String countryNativeName;
  final String countryAlpha2Code;
  final String cityName;
  final String zipCode;
  final String streetName;
  final String streetType;
  final String streetNumber;
  final String description;
  final double locationLong;
  final double locationLat;

  BusinessAddress({
    @required this.businessId,
    @required this.countryName,
    this.countryNativeName,
    @required this.countryAlpha2Code,
    @required this.cityName,
    @required this.zipCode,
    @required this.streetName,
    @required this.streetType,
    @required this.streetNumber,
    @required this.description,
    @required this.locationLong,
    @required this.locationLat,
  });

  @override
  List<Object> get props => [
        businessId,
        countryName,
        countryNativeName,
        countryAlpha2Code,
        cityName,
        zipCode,
        streetName,
        streetType,
        streetNumber,
        description,
        locationLong,
        locationLat,
      ];
}
