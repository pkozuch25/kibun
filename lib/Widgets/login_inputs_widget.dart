import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/ViewModels/email_validator_model.dart';
import 'package:kibun/Widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

class LoginInputsWidget extends StatelessWidget {

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function() scrollUpOnInputTap;

  const LoginInputsWidget({
    super.key, 
    required this.emailController,
    required this.passwordController,
    required this.scrollUpOnInputTap,

  });

  @override
  Widget build(BuildContext context) {  
    final model = Provider.of<EmailValidatorModel>(context);
    return Column(
       children: [
        TextFieldWidget(
          borderSide: BorderSide.none,
          bottomPadding: 250,
          controller: emailController,
          inputColor: ColorPalette.neutralsWhite,
          labelStyleColor: ColorPalette.neutralsWhite,
          cursorColor: ColorPalette.neutralsWhite,
          fillColor: ColorPalette.black100,
          prefixIconColor: ColorPalette.neutralsWhite,
          suffixIconColor: ColorPalette.neutralsWhite,
          borderSideColor: ColorPalette.neutralsWhite,
          hintText: 'Email',
          onChanged: (value) {
            model.isValidEmail(value);
          },
          onTap: () {
            scrollUpOnInputTap();
          },
          autoFillHints: const [AutofillHints.email],
          obscureText: false,
          prefixIconData: Icons.person_outline,
          suffixIconData: model.isValid == true ? Icons.check : null,
        ),
        const SizedBox(height: 20),
        TextFieldWidget(
          borderSide: BorderSide.none,
          bottomPadding: 250,
          controller: passwordController,
          inputColor: ColorPalette.neutralsWhite,
          labelStyleColor: ColorPalette.neutralsWhite,
          cursorColor: ColorPalette.neutralsWhite,
          fillColor: ColorPalette.black100,
          prefixIconColor: ColorPalette.neutralsWhite,
          suffixIconColor: ColorPalette.neutralsWhite,
          borderSideColor: ColorPalette.neutralsWhite,
          hintText: 'Password',
          onTap: () {
            scrollUpOnInputTap();
          },
          autoFillHints: const [AutofillHints.password],
          obscureText: model.isVisible ? false: true,
          prefixIconData: Icons.lock_outline,
          suffixIconData: model.isVisible ? Icons.visibility: Icons.visibility_off,
        ),
      ]
    );
  }
}