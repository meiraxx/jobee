import 'dart:convert' show utf8, json, jsonEncode, jsonDecode;
import 'dart:io' show HttpClient, HttpClientRequest, HttpClientResponse;

import 'package:http/http.dart' show Response, post;

class NetworkService {
  final String url;

  NetworkService(this.url);

  Future<String> apiRequest(Map<String, dynamic> jsonMap) async {
    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/x-www-form-urlencoded');
    request.add(utf8.encode(json.encode(jsonMap)));
    final HttpClientResponse response = await request.close();

    // TODO: should check the response.statusCode and throw an error
    final String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  Future<String> sendData(Map<String, dynamic> data) async {
    final Response response = await post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'No Data';
    }
  }

  Future<String> getData() async {
    final Response response = await post(Uri.parse(url),
        headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded'});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'No Data';
    }
  }

  static Future<Map<String, dynamic>>? getInfoByIP() async {
    final NetworkService n = NetworkService("http://ip-api.com/json");
    final String locationSTR = await n.getData();
    final Map<String, dynamic> ipLocation = jsonDecode(locationSTR) as Map<String, dynamic>;
    return ipLocation;
  }

  Future<int>? checkStatus() async {
    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();
    return response.statusCode;
  }
}