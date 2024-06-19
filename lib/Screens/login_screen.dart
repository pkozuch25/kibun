// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kibun/Logic/Enums/server_address_enum.dart';
import 'package:kibun/Logic/Services/color_palette.dart';
import 'package:kibun/Logic/Services/flushbar_service.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/ViewModels/email_validator_model.dart';
import 'package:kibun/Widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? _deviceName, _deviceId;

   void getDeviceName() async{
    try {
      if (Platform.isAndroid){
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
        _deviceId = androidInfo.id;
      } else if (Platform.isIOS){
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
        _deviceId = iosInfo.identifierForVendor;
      }
    } catch (e){
      log(e.toString());
    }
  }

    String loginMutation(String emailTemp, String passwordTemp) {
    return '''
      mutation{
        login( 
          email: "$emailTemp"
          password: "$passwordTemp"
          device: "${_deviceName ?? 'unknown'}$_deviceId"
        )
      }
    ''';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  setState(() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: ColorPalette.orange10
      )
    );
  });

  final HttpLink httpLink = HttpLink(ServerAddressEnum.LOCAL1.ipAddress);
  final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

  
  final model = Provider.of<EmailValidatorModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorPalette.orange40,
                  ColorPalette.orange30,
                  ColorPalette.orange20,
                  ColorPalette.orange10,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please login to continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorPalette.textGrey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFieldWidget(
                      borderSide: BorderSide.none,
                      bottomPadding: 250,
                      controller: _emailController,
                      inputColor: ColorPalette.textGrey,
                      labelStyleColor: ColorPalette.textGrey,
                      cursorColor: ColorPalette.textGrey,
                      fillColor: ColorPalette.orange05,
                      prefixIconColor: Colors.orange,
                      suffixIconColor: Colors.orange,
                      borderSideColor: Colors.orange.shade600,
                      hintText: 'Email',
                      autoFillHints: const [AutofillHints.email],
                      obscureText: false,
                      prefixIconData: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      borderSide: BorderSide.none,
                      bottomPadding: 250,
                      controller: _passwordController,
                      inputColor: ColorPalette.textGrey,
                      labelStyleColor: ColorPalette.textGrey,
                      cursorColor: ColorPalette.textGrey,
                      fillColor: ColorPalette.orange05,
                      prefixIconColor: Colors.orange,
                      suffixIconColor: Colors.orange,
                      borderSideColor: Colors.orange.shade600,
                      hintText: 'Password',
                      autoFillHints: const [AutofillHints.password],
                      obscureText: model.isVisible ? false: true,
                      prefixIconData: Icons.lock_outline,
                      suffixIconData: model.isVisible ? Icons.visibility: Icons.visibility_off,
                    ),
                    TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(foregroundColor: ColorPalette.darkOrange),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: ColorPalette.textGrey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                            try {
                                final MutationOptions options = MutationOptions(
                                  document: gql(loginMutation(_emailController.text, _passwordController.text)),
                                );      
                                final QueryResult queryResult = await client.value.mutate(options);
                                if (queryResult.hasException) {
                                  log(queryResult.exception.toString());
                                    FlushBarService(fitToScreen: 1, duration: 4).showCustomSnackBar(context, queryResult.exception?.graphqlErrors.first.message ?? 'Unknown error', ColorPalette.errorColor, const Icon(Icons.error, color: Colors.white, size: 18));
                                } else {
                                  () async {
                                    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
                                    StorageService().saveToken(queryResult.data?['login']);
                                    log(queryResult.data?['login']);
                                    // Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => Home(name: credentials['name'], email: credentials['email'])),
                                    //   (Route<dynamic> route) => false,
                                    // );
                                  }();
                                }
                              } catch (e) {
                                log(e.toString());
                              }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorPalette.darkOrange,
                        backgroundColor: ColorPalette.orange05,
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorPalette.textGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(foregroundColor: ColorPalette.darkOrange),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: ColorPalette.textGrey,
                    ),
                  ),
                  Text(' Register now',
                    style: TextStyle(
                      fontSize: 16.5,
                      color: ColorPalette.textGrey,
                      fontWeight: FontWeight.bold
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}