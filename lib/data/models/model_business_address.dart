import 'package:allbert_cms/domain/entities/entity_business_address.dart';
import 'package:meta/meta.dart';

class BusinessAddressModel extends BusinessAddress {
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

  BusinessAddressModel({
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
    this.locationLong,
    this.locationLat,
  }) : super(
          businessId: businessId,
          countryName: countryName,
          countryAlpha2Code: countryAlpha2Code,
          cityName: cityName,
          zipCode: zipCode,
          streetName: streetName,
          streetNumber: streetNumber,
          streetType: streetType,
          description: description,
          locationLat: locationLat,
          locationLong: locationLong,
        );

  factory BusinessAddressModel.fromJson(Map<String, dynamic> json) {
    return BusinessAddressModel(
      businessId: json["businessId"],
      countryName: json["countryName"],
      countryNativeName: json["countryNativeName"] ?? null,
      countryAlpha2Code: json["countryAlpha2Code"],
      cityName: json["cityName"],
      zipCode: json["zipCode"],
      streetName: json["streetName"],
      streetType: json["streetType"],
      streetNumber: json["streetNumber"],
      description: json["description"],
      locationLong: json["locationLong"],
      locationLat: json["locationLat"],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      "businessId": this.businessId,
      "countryName": this.countryName,
      "countryNativeName": this.countryNativeName,
      "countryAlpha2Code": this.countryAlpha2Code,
      "cityName": this.cityName,
      "zipCode": this.zipCode,
      "streetName": this.streetName,
      "streetType": this.streetType,
      "streetNumber": this.streetNumber,
      "description": this.description,
      "locationLong": this.locationLong ?? 0,
      "locationLat": this.locationLat ?? 0,
    };
    return map;
  }
}
