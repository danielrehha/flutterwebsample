import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:meta/meta.dart';

class ServiceModel extends Service implements ISerializable<ServiceModel> {
  final String id;
  final String name;
  final double cost;
  final int duration;
  final String currency;
  final String businessId;
  final bool enabled;
  final DateTime createdOn;

  ServiceModel({
    @required this.id,
    @required this.name,
    @required this.cost,
    @required this.duration,
    @required this.currency,
    @required this.businessId,
    @required this.enabled,
    this.createdOn,
  }) : super(
          id: id,
          name: name,
          cost: cost,
          duration: duration,
          currency: currency,
          businessId: businessId,
          enabled: enabled,
          createdOn: createdOn,
        );

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      duration: json['duration'],
      currency: json['currency'],
      businessId: json['businessId'],
      enabled: json["enabled"],
      createdOn: DateTime.parse(json["createdOn"]),
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'id': this.id,
      'name': this.name,
      'cost': this.cost,
      'duration': this.duration,
      'currency': this.currency,
      'businessId': this.businessId,
      "enabled": this.enabled,
      "createdOn": this.createdOn.toIso8601String(),
    };
    return map;
  }

  ServiceModel copyWith({
    String id,
    String name,
    double cost,
    int duration,
    String currency,
    String businessId,
    bool enabled,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      duration: duration ?? this.duration,
      currency: currency ?? this.currency,
      businessId: businessId ?? this.businessId,
      enabled: enabled ?? this.enabled,
    );
  }

  String get publicId => id.substring(4, 6);

  @override
  ServiceModel fromJson(Map<String, dynamic> json) {
    return ServiceModel.fromJson(json);
  }
}
