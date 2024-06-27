import 'package:flutter/material.dart';
import 'package:kibun/Widgets/background_widget.dart';


class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {

  

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
            Center(child: Text('settings')),
          ],
        ),
      ),
    );
  }
}