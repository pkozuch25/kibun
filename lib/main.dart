import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kibun/Logic/Services/color_palette.dart';
import 'package:kibun/Screens/InternetConnection/connection_alert.dart';
import 'package:kibun/Screens/login_screen.dart';
import 'package:kibun/ViewModels/email_validator_model.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: ColorPalette.backgroundColor
    )
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      textDirection: TextDirection.ltr,
      children: [
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => EmailValidatorModel()),
          ],
          child: MaterialApp(
            theme: ThemeData(
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: ColorPalette.orange40
              ),
              dialogTheme: DialogTheme(
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)
                )
              ),
              primaryColor: ColorPalette.orange40,
              cardTheme: CardTheme(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)
                )
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)
                  )
                )
              ),
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
            ),
            title: "Hotel rent",
            initialRoute: '/Screens/login_screen',
            routes: {
              '/Screens/login_screen': (context) => const LoginScreen(),
            }),
        ),
        const ConnectionAlert(),
      ],
    );
  }
}
