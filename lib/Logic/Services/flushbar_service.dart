import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kibun/Logic/Services/style.dart';

class FlushBarService {

final bool? positionOnTop;
final int? duration;
final int? fitToScreen;
FlushBarService({this.positionOnTop, this.duration, this.fitToScreen});

void showCustomSnackBar(BuildContext context, String message, Color color, Icon icon) {
   Flushbar(
      flushbarPosition: positionOnTop == true ? FlushbarPosition.TOP: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.easeOut,
      backgroundColor: color,
      borderRadius: BorderRadius.circular(3),
      duration: Duration(seconds: duration == null ? 2 : int.parse(duration.toString())),
      icon: icon,
      messageText: fitToScreen == 0 || fitToScreen == null ? Text(
        message,
        style: const TextStyle(fontSize: FontSize.regular, color: Colors.white, fontFamily: FontFamily.shadowsIntoLightTwo),
      ) : FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          message,
          style: const TextStyle(fontSize: FontSize.regular, color: Colors.white, fontFamily: FontFamily.shadowsIntoLightTwo),
        ),
      ),
    ).show(context);
  }
}
