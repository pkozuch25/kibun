import 'package:flutter/material.dart';
import 'package:kibun/Widgets/background_widget.dart';


class PlaylistsTab extends StatefulWidget {
  const PlaylistsTab({super.key});

  @override
  State<PlaylistsTab> createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<PlaylistsTab> {

  

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: BackgroundWidget(
        child: Column(
          children: [
            Center(child: Text('search')),
          ],
        ),
      ),
    );
  }
}