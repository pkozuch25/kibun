import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Screens/music_player_screen.dart';

class GeneralTabWidget extends StatelessWidget {
  final String artist;
  final String trackImageUrl;
  final String songName;
  final String albumName;
  final String trackId;
  final Color color;

  const GeneralTabWidget({
    super.key, 
    required this.artist,
    required this.trackImageUrl,
    required this.songName,
    required this.albumName,
    required this.trackId,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              showDragHandle: true,
              backgroundColor: ColorPalette.black500, 
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 70),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Builder(
                          builder: (context) {
                            return ListTile(title: Text('Zmień położenie'), iconColor: Colors.grey.shade800, textColor: Colors.grey.shade800, 
                            onTap: (){
                              Navigator.pop(context);
                              Future(() => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicPlayerScreen(trackId: trackId)
                                )
                              )); 
                            }, trailing: Icon(Icons.move_down));
                          }
                        ),
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
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        songName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.main16,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        artist,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.main14
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        albumName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.main12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
