import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class CrudRequestHandler {
  Dio dio = Dio();
  final client = http.Client();

  Future<Map<String, dynamic>> post({
    @required String url,
    @required dynamic data,
  }) async {
    final result = await dio.post(url,
        data: data,
        options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status <= 500;
            }));
    return result.data;
  }

  Future<Response> postRaw({
    @required String url,
    @required dynamic data,
  }) async {
    final result = await dio.post(url,
        data: data,
        options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status <= 500;
            }));
    return result;
  }

  Future<Map<String, dynamic>> getDio({
    @required String url,
  }) async {
    final result = await dio.get(url,
        options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status <= 500;
            }));
    return result.data;
  }

  Future<Map<String, dynamic>> get({
    @required String url,
  }) async {
    final result = await client.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    final json = jsonDecode(result.body);
    return json;
  }

  Future<dynamic> getWithRawResponse({
    @required String url,
  }) async {
    final result = await client.get(Uri.parse(url), headers: {
      "Access-Control-Allow-Origin": "*",
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    return result;
  }

  Future<Response> getWithRawResponseDio({
    @required String url,
  }) async {
    final result = await dio.get(url,
        options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              "Access-Control-Allow-Origin": "*"
            },
            validateStatus: (status) {
              return status <= 500;
            }));
    return result;
  }

  Future<Response<dynamic>> getRaw({
    @required String url,
  }) async {
    final result = await dio.get(url,
        options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status <= 500;
            }));
    return result;
  }

  Future<Map<String, dynamic>> delete({@required String url}) async {
    final result = await dio.delete(url,
        options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status <= 500;
            }));
    return result.data;
  }

    Future<Response<dynamic>> deleteRaw({
    @required String url,
  }) async {
    final result = await dio.delete(url,
        options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status <= 500;
            }));
    return result;
  }
}
