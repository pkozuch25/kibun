import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kibun/Logic/Services/play_spotify_track_service.dart';
import 'package:kibun/Logic/Services/style.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String trackId;

  const MusicPlayerScreen({super.key, required this.trackId});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorPalette.black500,
      // backgroundColor: music.songColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.close, color: Colors.transparent),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Playing Now',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: ColorPalette.teal500),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage('https://www.etna.org.pl/wp-content/uploads/2022/12/Ogrod-dla-jezy-i-jaszczurek-10-1024x576.jpg'),
                            radius: 10,
                          ),
                          const SizedBox(width: 4),
                          Text(
                           'Jozik himself',
                            style: textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                  const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ],
              ),
              Center(
                    child: Image.network('https://www.etna.org.pl/wp-content/uploads/2022/12/Ogrod-dla-jezy-i-jaszczurek-10-1024x576.jpg'),
                          ),
                  Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'jozik' ?? '',
                            style: textTheme.titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            'jozik' ?? '-',
                            style: textTheme.titleMedium
                                ?.copyWith(color: Colors.white60),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.favorite,
                        color: ColorPalette.teal500,
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder(
                      stream: player.onPositionChanged,
                      builder: (context, data) {
                        return ProgressBar(
                          progress:  const Duration(seconds: 0),
                          total: const Duration(minutes: 4),
                          bufferedBarColor: Colors.white38,
                          baseBarColor: Colors.white10,
                          thumbColor: Colors.white,
                          timeLabelTextStyle:
                              const TextStyle(color: Colors.white),
                          progressBarColor: Colors.white,
                          onSeek: (duration) {
                            player.seek(duration);
                          },
                        );
                      }),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white, size: 36)),
                      IconButton(
                          onPressed: () async {
                            PlaySpotifyTrackService().connectToSpotifyRemote(dotenv.env['CLIENT_ID'].toString());
                            print(widget.trackId);
                            PlaySpotifyTrackService().getAccessToken();
                            // PlaySpotifyTrackService().play(widget.trackId);
                            if (player.state == PlayerState.playing) {
                              await player.pause();
                            } else {
                              await player.resume();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                           player.state == PlayerState.playing
                                ? Icons.pause
                                : Icons.play_circle, 
                                size: 60,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.skip_next,
                              color: Colors.white, size: 36)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.loop,
                              color: ColorPalette.teal500)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
    );
  }
}