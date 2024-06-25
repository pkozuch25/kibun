import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/ViewModels/email_validator_model.dart';
import 'package:kibun/Widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

class RegistrationInputsWidget extends StatelessWidget {

  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final void Function() scrollUpOnInputTap;
  final void Function() onSuffixIconTap;
  final bool shouldPasswordConfirmationBeVisible;

  const RegistrationInputsWidget({
    super.key, 
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.scrollUpOnInputTap,
    required this.onSuffixIconTap,
    required this.shouldPasswordConfirmationBeVisible,

  });

  @override
  Widget build(BuildContext context) {  
    final model = Provider.of<EmailValidatorModel>(context);
    return Column(
      children: [
        TextFieldWidget(
          borderSide: BorderSide.none,
          bottomPadding: 250,
          controller: usernameController,
          inputColor: ColorPalette.neutralsWhite,
          labelStyleColor: ColorPalette.neutralsWhite,
          cursorColor: ColorPalette.neutralsWhite,
          fillColor: ColorPalette.black100,
          prefixIconColor: ColorPalette.neutralsWhite,
          suffixIconColor: ColorPalette.neutralsWhite,
          borderSideColor: ColorPalette.neutralsWhite,
          hintText: 'Username',
          onTap: () {
            scrollUpOnInputTap();
          },
          obscureText: false,
          prefixIconData: Icons.person_outline,
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        TextFieldWidget(
          borderSide: BorderSide.none,
          bottomPadding: 250,
          controller: passwordConfirmationController,
          inputColor: ColorPalette.neutralsWhite,
          labelStyleColor: ColorPalette.neutralsWhite,
          cursorColor: ColorPalette.neutralsWhite,
          fillColor: ColorPalette.black100,
          prefixIconColor: ColorPalette.neutralsWhite,
          suffixIconColor: ColorPalette.neutralsWhite,
          borderSideColor: ColorPalette.neutralsWhite,
          hintText: 'Confirm password',
          onTap: () {
            scrollUpOnInputTap();
          },
          autoFillHints: const [AutofillHints.password],
          obscureText: shouldPasswordConfirmationBeVisible ? false: true,
          prefixIconData: Icons.lock_outline,
          suffixIconData: shouldPasswordConfirmationBeVisible ? Icons.visibility: Icons.visibility_off,
          onSuffixIconTap: onSuffixIconTap,
        ),
      ],
    );
  }
}