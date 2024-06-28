import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';

class BackgroundWidget extends StatelessWidget {

  final List<Color>? gradientColors;
  final Widget? child;

  const BackgroundWidget({
    super.key, 
    this.gradientColors,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors == null ? [
            ColorPalette.black300,
            ColorPalette.black400,
            ColorPalette.black500,
            ColorPalette.black600,
          ] : gradientColors!,
        ),
      ),
      child: child,
    );
  }
}