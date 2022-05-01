import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Country extends Equatable {
  final String name;
  final String nativeName;
  final String alpha2Code;

  Country({
    @required this.name,
    @required this.nativeName,
    @required this.alpha2Code,
  });
  @override
  List<Object> get props => [
        name,
        nativeName,
        alpha2Code,
      ];
}
