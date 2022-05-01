import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:meta/meta.dart';

class ApplicationImageModel extends ApplicationImage {
  final String id;
  final String pathUrl;

  ApplicationImageModel({
    @required this.id,
    @required this.pathUrl,
  }) : super(
          id: id,
          pathUrl: pathUrl,
        );

  factory ApplicationImageModel.fromJson(Map<String, dynamic> json) {
    return ApplicationImageModel(
      id: json['id'],
      pathUrl: json['pathUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'pathUrl': this.pathUrl,
    };
  }

  factory ApplicationImageModel.empty() {
    return ApplicationImageModel(
      id: null,
      pathUrl: null,
    );
  }

  ApplicationImageModel copyWith({
    String id,
    String pathUrl,
  }) {
    return ApplicationImageModel(
      id: id ?? this.id,
      pathUrl: pathUrl ?? this.pathUrl,
    );
  }
}
