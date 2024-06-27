import 'package:flutter/material.dart';
import 'package:kibun/Widgets/background_widget.dart';


class RecommendedTab extends StatefulWidget {
  const RecommendedTab({super.key});

  @override
  State<RecommendedTab> createState() => _RecommendedTabState();
}

class _RecommendedTabState extends State<RecommendedTab> {

  

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
            Center(child: Text('Recommended')),
          ],
        ),
      ),
    );
  }
}