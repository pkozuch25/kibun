import 'package:flutter/material.dart';
import 'package:kibun/Widgets/background_widget.dart';


class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {

  

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