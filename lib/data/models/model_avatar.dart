import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_avatar_image.dart';
import 'package:meta/meta.dart';

class AvatarImageModel extends AvatarImage implements ISerializable<AvatarImageModel>{
  final String entityId;
  final String pathUrl;
  final DateTime modifiedOn;

  AvatarImageModel({
    @required this.entityId,
    @required this.pathUrl,
    @required this.modifiedOn,
  }) : super(
          entityId: entityId,
          pathUrl: pathUrl,
          modifiedOn: modifiedOn,
        );

  factory AvatarImageModel.fromJson(Map<String, dynamic> json) {
    return AvatarImageModel(
      entityId: json['entityId'],
      pathUrl: json['pathUrl'],
      modifiedOn: DateTime.parse(
        json['modifiedOn'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entityId': this.entityId,
      'pathUrl': this.pathUrl,
      'modifiedOn': this.modifiedOn,
    };
  }

  AvatarImageModel copyWith({
    String entityId,
    String pathUrl,
    DateTime modifiedOn,
  }) {
    return AvatarImageModel(
      entityId: entityId ?? this.entityId,
      pathUrl: pathUrl ?? this.pathUrl,
      modifiedOn: modifiedOn ?? this.modifiedOn,
    );
  }

  @override
  AvatarImageModel fromJson(Map<String, dynamic> json) {
    return AvatarImageModel.fromJson(json);
  }
}
