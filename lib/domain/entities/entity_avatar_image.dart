import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AvatarImage extends Equatable {
  final String entityId;
  final String pathUrl;
  final DateTime modifiedOn;

  AvatarImage({
    @required this.entityId,
    @required this.pathUrl,
    @required this.modifiedOn,
  });

  @override
  List<Object> get props => [
        entityId,
        pathUrl,
        modifiedOn,
      ];
}
