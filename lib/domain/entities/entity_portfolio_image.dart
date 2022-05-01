import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PortfolioImage extends Equatable {
  final String id;
  final String pathUrl;
  final String entityId;
  final DateTime modifiedOn;

  PortfolioImage({
    @required this.id,
    @required this.pathUrl,
    @required this.entityId,
    @required this.modifiedOn,
  });

  @override
  List<Object> get props => [
        id,
        pathUrl,
        entityId,
        modifiedOn,
      ];
}
