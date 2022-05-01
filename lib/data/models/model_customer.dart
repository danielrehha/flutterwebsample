import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/data/models/model_customer_info.dart';
import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_avatar_image.dart';
import 'package:allbert_cms/domain/entities/entity_customer.dart';
import 'package:allbert_cms/domain/entities/entity_customer_info.dart';
import 'package:meta/meta.dart';

class CustomerModel extends Customer implements ISerializable<CustomerModel> {
  final String id;
  final CustomerInfoModel info;
  final ApplicationImageModel avatar;
  final DateTime createdOn;

  CustomerModel({
    @required this.id,
    @required this.info,
    @required this.avatar,
    this.createdOn,
  }) : super(
          id: id,
          info: info,
          avatar: avatar,
        );

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      info: CustomerInfoModel.fromJson(json['customerInfo']),
      avatar: json["avatar"] == null
          ? ApplicationImageModel.empty()
          : ApplicationImageModel.fromJson(json['avatar']),
      createdOn:
          json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'customerInfo': this.info.toJson(),
      'avatar': this.avatar.toJson(),
    };
  }

  CustomerModel copyWith({
    String id,
    CustomerInfo info,
    AvatarImage avatar,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      info: info ?? this.info,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  CustomerModel fromJson(Map<String, dynamic> json) {
    return CustomerModel.fromJson(json);
  }
}
