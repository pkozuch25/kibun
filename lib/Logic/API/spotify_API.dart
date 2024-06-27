import 'dart:convert';

import 'package:http/http.dart' as http;

///Performs a request to Spotify API.
Future<Map<String, dynamic>> callSpotifyAPI(String endpoint,
    Map<String, String> headers, Map<String, String>? body) async {
  String? requestParameters = convertBody(body);
  String endpointURL = requestParameters == null
      ? "https://api.spotify.com/v1/$endpoint"
      : "https://api.spotify.com/v1/$endpoint?$requestParameters";
  http.Response response =
      await http.get(Uri.parse(endpointURL), headers: headers);
  return (jsonDecode(response.body));
}

///Converts body into a GET parameter string.
String? convertBody(Map<String, String>? requestBody) {
  List<String> parameters = [];
  if (requestBody == null) {
    return null;
  }
  requestBody.forEach((name, value) => parameters.add("$name=$value"));
  String joinedParameters = parameters.join("&").replaceAll(RegExp(r','), "%2C");
  return (joinedParameters);
}
