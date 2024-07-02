// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kibun/Logic/Enums/server_address_enum.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/Logic/Services/flushbar_service.dart';
import 'package:kibun/Logic/Services/storage_service.dart';
import 'package:kibun/Screens/login_screen.dart';
import 'package:kibun/Screens/navbar_scaffolding_screen.dart';
import 'package:kibun/Widgets/background_widget.dart';
import 'package:kibun/Widgets/registration_inputs_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool shouldPasswordConfirmationBeVisible = true;

  void scrollUpOnInputTap() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease
    );
  }

  String registerMutation(String username, String email, String password, String confirmPassword) {
    return '''
      mutation{
        register(
          input: {
            name: "$username" 
            email: "$email"
            password: "$password"
            password_confirmation: "$confirmPassword"
          }
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
    final Widget svg = SvgPicture.asset(
      width: 150,
      height: 150,
      'assets/kibun_logo.svg',
    );
    final HttpLink httpLink = HttpLink(ServerAddressEnum.PUBLIC1.ipAddress);
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Please register to continue',
                  style: TextStyle(
                    fontSize: FontSize.regular,
                    color: ColorPalette.neutralsWhite,
                  ),
                ),
                const SizedBox(height: 20),
                svg,
                const SizedBox(height: 20),
                RegistrationInputsWidget(
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  passwordConfirmationController: _passwordConfirmationController,
                  emailController: _emailController,
                  shouldPasswordConfirmationBeVisible: shouldPasswordConfirmationBeVisible,
                  scrollUpOnInputTap: scrollUpOnInputTap,
                  onSuffixIconTap: () {
                    setState(() {
                      shouldPasswordConfirmationBeVisible = !shouldPasswordConfirmationBeVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                        final MutationOptions options = MutationOptions(
                          document: gql(registerMutation(_usernameController.text, _emailController.text, _passwordController.text, _passwordConfirmationController.text)),
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
                            StorageService().saveToken(queryResult.data?['register']);
                            FlushBarService(fitToScreen: 1, duration: 4).showCustomSnackBar(
                              context,
                              'Registration was successful!',
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
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(foregroundColor: ColorPalette.teal200),
                  child: const FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: ColorPalette.neutralsWhite,
                          ),
                        ),
                        Text(' Back to login',
                          style: TextStyle(
                            fontSize: FontSize.small,
                            color: ColorPalette.neutralsWhite,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}