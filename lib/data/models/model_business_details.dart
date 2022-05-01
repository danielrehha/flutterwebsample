import 'package:allbert_cms/domain/entities/entity_business_details.dart';
import 'package:meta/meta.dart';

class BusinessDetailsModel extends BusinessDetails {
  final String businessId;
  final String name;
  final String type;
  final String description;

  BusinessDetailsModel({
    @required this.businessId,
    @required this.name,
    @required this.type,
    @required this.description,
  }) : super(
          businessId: businessId,
          name: name,
          type: type,
          description: description,
        );

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsModel(
      businessId: json["businessId"],
      name: json["name"],
      type: json["type"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "businessId": this.businessId,
      "name": this.name,
      "type": this.type,
      "description": this.description,
    };
  }

  BusinessDetailsModel copyWith({
    String businessId,
    String name,
    String type,
    String description,
  }) {
    return BusinessDetailsModel(
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}
