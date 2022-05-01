import 'package:allbert_cms/data/types/i_serializable.dart';
import 'package:allbert_cms/domain/entities/entity_portfolio_image.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class PortfolioImageModel extends PortfolioImage implements ISerializable<PortfolioImageModel>{
  final String id;
  final String pathUrl;
  final String entityId;
  final DateTime modifiedOn;

  PortfolioImageModel({
    @required this.id,
    @required this.pathUrl,
    @required this.entityId,
    @required this.modifiedOn,
  }) : super(
          id: id,
          pathUrl: pathUrl,
          entityId: entityId,
          modifiedOn: modifiedOn,
        );

  factory PortfolioImageModel.fromJson(Map<String, dynamic> json) {
    return PortfolioImageModel(
        id: json['id'],
        pathUrl: json['pathUrl'],
        entityId: json['entityId'],
        modifiedOn: DateTime.parse(json['modifiedOn']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'pathUrl': this.pathUrl,
      'entityId': this.entityId,
      'modifiedOn': this.modifiedOn,
    };
  }

  PortfolioImageModel copyWith({
    String id,
    String pathUrl,
    Uuid entityId,
    DateTime modifiedOn,
  }) {
    return PortfolioImageModel(
      id: id ?? this.id,
      pathUrl: pathUrl ?? this.pathUrl,
      entityId: entityId ?? this.entityId,
      modifiedOn: modifiedOn ?? this.modifiedOn,
    );
  }

  @override
  PortfolioImageModel fromJson(Map<String, dynamic> json) {
    return PortfolioImageModel.fromJson(json);
  }
}
