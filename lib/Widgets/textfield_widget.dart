import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kibun/Logic/Services/style.dart';
import 'package:kibun/ViewModels/email_validator_model.dart';
import 'package:provider/provider.dart';


class TextFieldWidget extends StatelessWidget {

  final String hintText;
  final IconData prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final VoidCallback? onSuffixIconTap;
  final TextEditingController controller;
  final String? Function(String? val)? validator;
  final TextInputType? keyboardType;
  final Color? inputColor;
  final Color? cursorColor;
  final Color? prefixIconColor;
  final Color borderSideColor;
  final Color? suffixIconColor;
  final Color? labelStyleColor;
  final Color? fillColor;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatter;
  final FocusNode? focusNode;
  final BorderSide borderSide;
  final int bottomPadding;
  final Iterable<String>? autoFillHints;
  final GlobalKey _accKey = GlobalKey();
  final TextCapitalization? textCapitalization;

  TextFieldWidget({super.key,  
    required this.hintText,
    required this.prefixIconData,
    required this.obscureText,
    this.onChanged,
    this.onTap,
    required this.borderSideColor,
    required this.borderSide,
    required this.bottomPadding,
    required this.controller,
    this.onSuffixIconTap,
    this.keyboardType,
    this.suffixIconData,
    this.focusNode,
    this.validator,
    this.inputColor,
    this.cursorColor,
    this.maxLength,
    this.prefixIconColor,
    this.suffixIconColor,
    this.labelStyleColor,
    this.fillColor,
    this.inputFormatter,
    this.autoFillHints,
    this.textCapitalization
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EmailValidatorModel>(context);
    return TextFormField(
      textCapitalization: textCapitalization == null ? TextCapitalization.none: textCapitalization!,
      maxLength: maxLength,
      inputFormatters: inputFormatter,
      focusNode: focusNode,
      autofillHints: autoFillHints,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + bottomPadding),
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: inputColor,
        fontSize: FontSize.small,
        fontWeight: FontWeight.w400
      ),
      cursorColor: cursorColor,
      decoration: InputDecoration(
        filled: true,
        counterText: '',
        labelText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(color: labelStyleColor),
        prefixIcon: Icon(
          prefixIconData,
          size: 22,
          color: prefixIconColor,
        ),
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: borderSideColor),
        ),
        suffixIcon: GestureDetector(
          key: _accKey,
          onTap: onSuffixIconTap ?? () {
            if (suffixIconData == Icons.visibility_off || suffixIconData == Icons.visibility) {
              model.isVisible = !model.isVisible;
            }
          },
          child: Icon(
            suffixIconData,
            size: 22,
            color: suffixIconColor,
          ),
        ),
      ),
    );
  }
}