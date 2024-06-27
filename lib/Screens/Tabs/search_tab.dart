import 'package:flutter/material.dart';
import 'package:kibun/Widgets/background_widget.dart';


class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {

  

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