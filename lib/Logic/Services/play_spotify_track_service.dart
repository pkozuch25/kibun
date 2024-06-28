import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlaySpotifyTrackService {
  Future<void> connectToSpotifyRemote(String clientId) async {
    try {
      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId,
        redirectUrl: 'https://www.beatbracket.com/',
        scope: 'app-remote-control,user-modify-playback-state,playlist-read-private'
      );
      print('connect to spotify remote result: $result');
    } catch (e) {
      print('error connecting to spotify remote: $e');
    }
  }
  
Future<String> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: 'http://localhost/',
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      return authenticationToken;
    } on PlatformException catch (e) {
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      return Future.error('not implemented');
    }
  }
  Future<void> play(String spotifyUri) async {
    try {
      await SpotifySdk.play(spotifyUri: spotifyUri);
      print('adasf');  
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code}");
    } on MissingPluginException {
      print("SpotifySDK not implemented");
  }
  }

}
