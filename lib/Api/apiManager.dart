import 'dart:convert';
import '../config.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  Map<String, dynamic> tryJsonDecode(String data) {
    try {
      return jsonDecode(data);
    } catch (error) {
      throw Exception('Failed to decode json');
    }
  }

  void checkStatusCode(var response) {
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> post(String url,
      [Map<String, dynamic>? apiBody,
      Map<String, String>? requestHeaders]) async {
    http.Response response = await http.post(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders, body: jsonEncode(apiBody ?? {}));

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }

  Future<Map<String, dynamic>> put(String url,
      [Map<String, dynamic>? apiBody,
      Map<String, String>? requestHeaders]) async {
    http.Response response = await http.put(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders, body: jsonEncode(apiBody ?? {}));

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }

  Future<Map<String, dynamic>> get(String url,
      [Map<String, String>? requestHeaders]) async {
    http.Response response = await http.get(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders);

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }

  Future<Map<String, dynamic>> delete(String url,
      [Map<String, String>? requestHeaders]) async {
    http.Response response = await http.delete(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders);

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }
}
