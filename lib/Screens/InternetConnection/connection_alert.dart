import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/connectivity_controller.dart';
import 'package:kibun/Widgets/Screens/no_internet_screen.dart';

class ConnectionAlert extends StatefulWidget {
  const ConnectionAlert({super.key});
  @override
  State<ConnectionAlert> createState() => _ConnectionAlertState();
}
class _ConnectionAlertState extends State<ConnectionAlert> {
  ConnectivityController connectivityController = ConnectivityController();

  @override
  void initState() {
    connectivityController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: connectivityController.isConnected,
      builder: (context, value, child) {
        if (value) {
          return const SizedBox();
        } else {
          return const NoInternetScreen();
        }
      }
    );
  }
}