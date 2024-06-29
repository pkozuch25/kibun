import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String songName;
  final String authorName;
  final String albumName;
  final String trackUrl;
  final int duration;

  const MusicPlayerScreen({super.key, required this.songName, required this.albumName, required this.authorName, required this.duration, required this.trackUrl});

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
      body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                      const SizedBox(height: 15),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                  }, icon: const Icon(
                    Icons.close, 
                    color: Colors.white
                    )
                  )
                ],
              ),
              Center(
                child: Image.network(widget.trackUrl),
              ),
              Column(
                children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          OverflowTextAnimated(
                            text: widget.authorName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.main16,
                            ),
                            animation: OverFlowTextAnimations.infiniteLoop,
                            loopSpace: 30,
                          ),
                          const SizedBox(height: 5),
                          OverflowTextAnimated(
                            text: widget.albumName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.main12,
                            ),
                            animation: OverFlowTextAnimations.infiniteLoop,
                            loopSpace: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder(
                    stream: player.onPositionChanged,
                    builder: (context, data) {
                      return ProgressBar(
                        progress: const Duration(seconds: 0),
                        total: Duration(milliseconds: widget.duration),
                        bufferedBarColor: Colors.white38,
                        baseBarColor: Colors.white10,
                        thumbColor: Colors.white,
                        timeLabelTextStyle: const TextStyle(color: Colors.white),
                        progressBarColor: Colors.white,
                        onSeek: (duration) {
                          player.seek(duration);
                        },
                      );
                    }
                  ),
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
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white, size: 36
                          )
                        ),
                    ],
                  )
                ],
              )
          ),
        );
  }
}