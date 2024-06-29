import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';

class PlaylistWidget extends StatelessWidget {
  final String albumImageUrl;
  final String albumName;
  final Color color;
  final int? songCount;
  final int playlistId;
  final void Function(BuildContext, int) navigateToTracksScreen;

  const PlaylistWidget({
    super.key, 
    required this.albumImageUrl,
    required this.albumName,
    required this.color,
    required this.songCount,
    required this.playlistId,
    required this.navigateToTracksScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      height: 200,
      child: GestureDetector(
        onTap: () async {
          navigateToTracksScreen(context, playlistId);
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
                albumImageUrl,
                fit: BoxFit.fill,
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
                        text: albumName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.main16,
                        ),
                        animation: OverFlowTextAnimations.infiniteLoop,
                        loopSpace: 30,
                      ),
                      OverflowTextAnimated(
                        text: 'Songs in this album: ${songCount == null ? 0 : songCount.toString()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.main14,
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
