import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Screens/login_screen.dart';
import 'package:kibun/Screens/navbar_scaffolding_screen.dart';
import 'package:kibun/Widgets/background_widget.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String? token;
  final String assetName = 'assets/kibun_logo.svg';

  @override
  void initState(){
    readToken();
    super.initState();
  }

  Future<void> readToken() async {
    token = await StorageService().readToken();
    if(!mounted) {
      return;
    }
    if(token != null && token != '') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavbarScaffoldingScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget svgLoading = SvgPicture.asset(
      width: 150,
      height: 150,
      assetName,
    );
    return Scaffold(
      body: BackgroundWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svgLoading,
            const CircularProgressIndicator(color: ColorPalette.teal500),
          ],
        ),
      )
    );
  }
}