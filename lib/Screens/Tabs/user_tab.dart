import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Screens/login_screen.dart';
import 'package:kibun/Widgets/background_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';


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
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorPalette.teal200,
              backgroundColor: ColorPalette.teal500,
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              StorageService().deleteDataAfterLogout();
              pushWithoutNavBar(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen())
              );
            }, 
          child: const Text('Log out', style: TextStyle(color: ColorPalette.black500),))
        ),
      )
    );
  }
}