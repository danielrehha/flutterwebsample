import 'package:allbert_cms/data/helpers/i_json_response_parser.dart';
import 'package:meta/meta.dart';

class JsonResponseParser implements IJsonResponseParser {
  Map<String, dynamic> parse({@required dynamic json, String objectKey}) {
    if (json['success'] == false) {
      return null;
    }
    return objectKey == null ? json : json[objectKey];
  }

    List<dynamic> parseList({@required dynamic json, String listKey}) {
    if (json['success'] == false) {
      return null;
    }
    return listKey == null ? json : json[listKey];
  }
}
