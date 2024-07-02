// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kibun/Logic/Enums/server_address_enum.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Logic/Services/flushbar_service.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/Screens/navbar_scaffolding_screen.dart';
import 'package:kibun/Screens/register_screen.dart';
import 'package:kibun/Widgets/background_widget.dart';
import 'package:kibun/Widgets/login_inputs_widget.dart';

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
  final ScrollController _scrollController = ScrollController();

  void getDeviceName() async { 
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

  void scrollUpOnInputTap() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease
    );
  }

  String loginMutation(String email, String password) {
    return '''
      mutation{
        login( 
          email: "$email"
          password: "$password"
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
          systemNavigationBarColor: ColorPalette.black600
        )
      );
    });

    final HttpLink httpLink = HttpLink(ServerAddressEnum.PUBLIC1.ipAddress);
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BackgroundWidget(
          child: Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.neutralsWhite,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please login to continue',
                    style: TextStyle(
                      fontSize: FontSize.regular,
                      color: ColorPalette.neutralsWhite,
                    ),
                  ),
                  const SizedBox(height: 40),
                  LoginInputsWidget(
                    emailController: _emailController, 
                    passwordController: _passwordController, 
                    scrollUpOnInputTap: scrollUpOnInputTap
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                          final MutationOptions options = MutationOptions(
                            document: gql(loginMutation(_emailController.text, _passwordController.text)),
                          );      
                          final QueryResult queryResult = await client.value.mutate(options);
                          if (queryResult.hasException) {
                            log(queryResult.exception.toString());
                              FlushBarService(fitToScreen: 1, duration: 4).showCustomSnackBar(context,
                                queryResult.exception?.graphqlErrors.first.message ?? 'Unknown error', ColorPalette.errorColor, const Icon(Icons.error, color: Colors.white, size: FontSize.regular));
                          } else {
                            () async {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight, DeviceOrientation.portraitDown, DeviceOrientation.portraitUp
                              ]);
                              StorageService().saveToken(queryResult.data?['login']);
                              log(queryResult.data?['login']);
                              FlushBarService(fitToScreen: 1, duration: 4).showCustomSnackBar(
                                context,
                                'Login was successful!',
                              ColorPalette.successColor, 
                                const Icon(
                                  Icons.error, 
                                  color: Colors.white, 
                                  size: FontSize.regular
                                )
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const NavbarScaffoldingScreen()),
                                (Route<dynamic> route) => false,
                              );
                            }();
                          }
                        } catch (e) {
                          log(e.toString());
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ColorPalette.teal200,
                      backgroundColor: ColorPalette.teal500,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: FontSize.regular,
                        color: ColorPalette.black500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(foregroundColor: ColorPalette.teal200),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: ColorPalette.neutralsWhite,
                          ),
                        ),
                        Text(' Register now',
                          style: TextStyle(
                            fontSize: FontSize.small,
                            color: ColorPalette.neutralsWhite,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}