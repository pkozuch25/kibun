// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kibun/Logic/API/Playlists/add_song_mutation.dart';
import 'package:kibun/Logic/API/Playlists/fetch_user_playlists_query.dart';
import 'package:kibun/Logic/Enums/server_address_enum.dart';
import 'package:kibun/Logic/Services/flushbar_service.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Screens/music_player_screen.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';

class GeneralTabWidget extends StatelessWidget {
  final String artist;
  final String trackImageUrl;
  final String songName;
  final String albumName;
  final String token;
  final Color color;
  final int durationMs;
  final bool? canAddToPlaylist;

  const GeneralTabWidget({
    super.key, 
    required this.artist,
    required this.trackImageUrl,
    required this.songName,
    required this.albumName,
    required this.color,
    required this.durationMs,
    required this.token,
    this.canAddToPlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: canAddToPlaylist == false ? 200 : null,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            showDragHandle: true,
            backgroundColor: ColorPalette.black500, 
            builder: (context) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 70),
                  child: Card(
                    elevation: 0,
                    color: ColorPalette.black500,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Builder(
                          builder: (context) {
                            return ListTile(tileColor: ColorPalette.black100, title: const Text('Play'), iconColor: ColorPalette.neutralsWhite, textColor: ColorPalette.neutralsWhite, 
                            onTap: () {
                              Navigator.pop(context);
                              Future(() => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicPlayerScreen(songName: songName, albumName: albumName, authorName: artist, duration: durationMs, trackUrl: trackImageUrl,)
                                )
                              )); 
                            }, trailing: const Icon(Icons.play_arrow));
                          }
                        ),
                        const SizedBox(height: 10,),
                       canAddToPlaylist != false ? Builder(
                          builder: (context) {
                            return ListTile(tileColor: ColorPalette.black100, title: const Text('Add to playlist'), iconColor: ColorPalette.neutralsWhite, textColor: ColorPalette.neutralsWhite, 
                            onTap: () async {
                              List<Map<String, dynamic>> listOfPlaylists = await FetchUserPlaylistsQuery().fetchData(1, ServerAddressEnum.PUBLIC1.ipAddress, token);
                              await showModalBottomSheet<void>(
                                isScrollControlled: true,
                                context: context,
                                showDragHandle: true,
                                backgroundColor: ColorPalette.black500, 
                                builder: (context) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 70),
                                      child: Card(
                                        elevation: 0,
                                        color: ColorPalette.black500,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for (var playlist in listOfPlaylists)
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10.0),
                                              child: ListTile(
                                                tileColor: ColorPalette.black100, 
                                                title: Text(playlist['name']), 
                                                iconColor: ColorPalette.neutralsWhite, 
                                                textColor: ColorPalette.neutralsWhite, 
                                                onTap: () async {
                                                  final HttpLink httpLink = HttpLink(ServerAddressEnum.PUBLIC1.ipAddress);
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
                                                  try {
                                                    final MutationOptions options = MutationOptions(
                                                      document: gql(AddSongMutation().addSongMutation(playlist['id'], durationMs, songName, artist, albumName, trackImageUrl)),
                                                    );      
                                                    final QueryResult queryResult = await client.value.mutate(options);
                                                    if (queryResult.hasException) {
                                                      log(queryResult.exception.toString());
                                                      FlushBarService(fitToScreen: 1, duration: 4).showCustomSnackBar(context,
                                                      queryResult.exception?.graphqlErrors.first.message ?? 'Unknown error', ColorPalette.errorColor, const Icon(Icons.error, color: Colors.white, size: FontSize.regular));
                                                    } else {
                                                        FlushBarService(fitToScreen: 1, duration: 4).showCustomSnackBar(
                                                          context,
                                                          'Added to playlist',
                                                        ColorPalette.successColor, 
                                                          const Icon(
                                                            Icons.error, 
                                                            color: Colors.white, 
                                                            size: FontSize.regular
                                                          )
                                                        );
                                                    }
                                                    } catch (e) {
                                                    log(e.toString());
                                                  }
                                                }, trailing: const Icon(Icons.playlist_add)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              }, trailing: const Icon(Icons.playlist_add));
                          }
                        ) : Container(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color,
                offset: const Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 1,
              )
            ]
          ),
          child: Stack(
            children: [
              Image.network(
                trackImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OverflowTextAnimated(
                        text: songName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.main16,
                        ),
                        animation: OverFlowTextAnimations.infiniteLoop,
                        loopSpace: 30,
                      ),
                      OverflowTextAnimated(
                        text: artist,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.main14,
                        ),
                        animation: OverFlowTextAnimations.infiniteLoop,
                        loopSpace: 30,
                      ),
                      OverflowTextAnimated(
                        text: albumName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.main12,
                        ),
                        animation: OverFlowTextAnimations.infiniteLoop,
                        loopSpace: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
