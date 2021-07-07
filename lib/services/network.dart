import 'package:http/http.dart' show Response, post;
import 'dart:io' show HttpClient, HttpClientRequest, HttpClientResponse;
import 'dart:convert' show utf8, json, jsonEncode, jsonDecode;

class NetworkService {
  final String url;

  NetworkService(this.url);

  Future<String> apiRequest(Map jsonMap) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/x-www-form-urlencoded');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    print(response.statusCode);
    // TODO: should check the response.statusCode and throw an error
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  Future<String> sendData(Map data) async {
    Response response = await post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data));
    if (response.statusCode == 200)
      return (response.body);
    else
      return 'No Data';
  }

  Future<String> getData() async {
    Response response = await post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    if (response.statusCode == 200)
      return (response.body);
    else
      return 'No Data';
  }

  static Future<Map<String, dynamic>>? getInfoByIP() async {
    NetworkService n = new NetworkService("http://ip-api.com/json");
    String locationSTR = (await n.getData());
    Map<String, dynamic> ipLocation = jsonDecode(locationSTR) as Map<String, dynamic>;
    return ipLocation;
  }

  Future<int>? checkStatus() async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    return response.statusCode;
  }
}