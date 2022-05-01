import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Notification extends Equatable {
  final String id;
  final String title;
  final String content;
  final String navigationRoute;
  final DateTime createdOn;

  Notification({
    @required this.id,
    @required this.title,
    @required this.content,
    @required this.createdOn,
    this.navigationRoute,
  });

  @override
  List<Object> get props => [
    id,
        title,
        content,
        navigationRoute,
        createdOn,
      ];
}
