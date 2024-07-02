import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FetchSongsInPlaylistQuery {   
   
  Future<List<Map<String, dynamic>>> fetchData(int pageKey, int playlistId, link, token) async {
    final HttpLink httpLink = HttpLink(link.toString());
    final authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    Link concatLink = authLink.concat(httpLink);

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: concatLink,
        cache: GraphQLCache(),
      ),
    );
    String query = infoQuery(pageKey, playlistId);
    final QueryOptions options = QueryOptions(
      document: gql(query),
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      throw result.exception!;
    }
    final data = result.data?['getUserSongsInPlaylist']['data'];
    if (data == null) {
      return [];
    }

    final List<Map<String, dynamic>> dataList =
        (data as List?)?.cast<Map<String, dynamic>>() ?? [];
    return dataList;
  }
}

 String infoQuery(int pageKey, int playlistId) {
    return '''
      query{
        getUserSongsInPlaylist(first: 10, page: $pageKey, playlistId: $playlistId) {
          data {
            id
            durationMs
            artistAlbumName
            artistName
            trackImageUrl
            trackName
          }
        }
      }
    ''';
  }
