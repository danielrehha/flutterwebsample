import 'package:meta/meta.dart';

abstract class IJsonResponseParser {
  Map<String, dynamic> parse({@required dynamic json, String objectKey});
}