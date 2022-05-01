import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ApplicationImage extends Equatable {
  final String id;
  final String pathUrl;
  final Uint8List bytes;

  ApplicationImage({
    @required this.id,
    @required this.pathUrl,
    this.bytes,
  });

  @override
  List<Object> get props => [
        id,
        pathUrl,
        bytes,
      ];
}
