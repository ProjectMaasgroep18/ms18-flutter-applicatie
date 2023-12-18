import 'dart:convert';
import '../config.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  static T tryJsonDecode<T>(String data) {
    try {
      
      return json.decode(data) as T;
    } catch (error) {

      throw Exception('Failed to decode json');
    }
  }

  static void checkStatusCode(var response) {
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  static Future<T> post<T>(String url,
      [Map<String, dynamic>? apiBody,
      Map<String, String>? requestHeaders]) async {
    http.Response response = await http.post(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders, body: jsonEncode(apiBody ?? {}));

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }

  static Future<T> put<T>(String url,
      [Map<String, dynamic>? apiBody,
      Map<String, String>? requestHeaders]) async {
    http.Response response = await http.put(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders, body: jsonEncode(apiBody ?? {}));

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }

  static Future<T> get<T>(String url,
      [Map<String, String>? requestHeaders]) async {
    http.Response response = await http.get(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders);

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }

  static Future<T> delete<T>(String url,
      [Map<String, String>? requestHeaders]) async {
    http.Response response = await http.delete(Uri.parse(apiUrl + url),
        headers: requestHeaders ?? apiHeaders);

    checkStatusCode(response);
    return tryJsonDecode(response.body);
  }
}
