import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: ColorPalette.black300,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.wifi_slash,
                size: 100,
                color: ColorPalette.teal200,
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Unable to establish network connection",
                    style: TextStyle(
                      color: ColorPalette.teal200,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Ensure your device is online',
                style: TextStyle(
                  color: ColorPalette.teal200,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
