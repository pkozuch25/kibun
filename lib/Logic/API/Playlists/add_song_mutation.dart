 class AddSongMutation {
  String addSongMutation(int playlistId, int durationMs, String trackName, String artistName, String artistAlbumName, String trackImageUrl) {
    print('$playlistId $durationMs $trackName $artistName $artistAlbumName $trackImageUrl');
    return '''
      mutation {
        addTrackToPlaylist(
          playlistId: $playlistId,
          durationMs: $durationMs,
          trackName: "$trackName",
          artistName: "$artistName",
          artistAlbumName: "$artistAlbumName",
          trackImageUrl: "$trackImageUrl",
        )
      }
    ''';
  }
 }