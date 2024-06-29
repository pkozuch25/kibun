// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;

class SpotifyApi {
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

  Future<List<Map<String, dynamic>>> getSpotifyRecommendations(String accessToken, List<String> seedGenres, int limit) async {
    // Set up headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // Set up body parameters
    Map<String, String> body = {};
    body['seed_genres'] = seedGenres.join(',');
    body['limit'] = limit.toString();

    // Perform the API call
    return parseSpotifyResponse(await callSpotifyAPI('recommendations', headers, body));
  }

  Future<List<Map<String, dynamic>>> searchForTrack(String accessToken, String search, int limit) async {
    // Set up headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    List<String> searchTypes = ['artist', 'track'];
    // Set up body parameters
    Map<String, String> body = {};
    body['q'] = search;
    body['limit'] = limit.toString();
    body['type'] = searchTypes.join('%2C');

    // Perform the API call
    return parseSpotifyResponse(await callSpotifyAPI('search', headers, body), type: 'searching');
  }

  /// Parses the Spotify API response to extract the required fields.
  List<Map<String, dynamic>> parseSpotifyResponse(Map<String, dynamic> response, {String? type}) {
    List<Map<String, dynamic>> tracks = [];

    if (type == 'searching') {
      tracks = (response['tracks']['items'] as List).map((track) => {
        'artist': (track['artists'] as List).map((artist) => artist['name']).join(', '),
        'trackImageUrl': track['album']['images'][0]['url'],
        'songName': track['name'],
        'albumName': track['album']['name'],
        'durationMs': track['duration_ms'],
        'trackId': track['uri'],
      }).toList();
    } else {
    tracks = (response['tracks'] as List).map((track) => {
        'artist': (track['artists'] as List).map((artist) => artist['name']).join(', '),
        'trackImageUrl': track['album']['images'][0]['url'],
        'songName': track['name'],
        'albumName': track['album']['name'],
        'durationMs': track['duration_ms'],
        'trackId': track['uri'],
      }).toList();
    }
    return tracks;
  }
}