import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Screens/InternetConnection/connection_alert.dart';
import 'package:kibun/Screens/loading_screen.dart';
import 'package:kibun/ViewModels/email_validator_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: ColorPalette.black600
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
                color: ColorPalette.teal700
              ),
              dialogTheme: DialogTheme(
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)
                )
              ),
              primaryColor: ColorPalette.black300,
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
            title: "Kibun",
            initialRoute: '/Screens/loading_screen',
            routes: {
              '/Screens/loading_screen': (context) => const LoadingScreen(),
            }),
        ),
        const ConnectionAlert(),
      ],
    );
  }
}
