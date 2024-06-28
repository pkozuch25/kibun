import 'dart:math';

import 'package:flutter/material.dart';

class ColorPalette {
  static const Color successColor = Color(0xff5cb85c);
  static const Color errorColor = Color.fromARGB(255, 194, 17, 17);
  static const Color black100 = Color(0xff787878);
  static const Color black200 = Color(0xff60635d);
  static const Color black300 = Color(0xff525351);
  static const Color black400 = Color(0xff41443f);
  static const Color black500 = Color(0xff383937);
  static const Color black600 = Color(0xff313230);
  static const Color black700 = Color(0xff262725);
  static const Color black800 = Color(0xff121312);
  static const Color teal100 = Color(0xffe9fff4);
  static const Color teal200 = Color(0xffd3ffea);
  static const Color teal300 = Color(0xffbdffe0);
  static const Color teal400 = Color(0xffa7ffd5);
  static const Color teal500 = Color(0xff87ffc5);
  static const Color teal600 = Color(0xff66ffb5);
  static const Color teal700 = Color(0xff50ffab);
  static const Color teal800 = Color(0xff24ff96);
  static const Color neutralsWhite = Color(0xffffffff);
  static const Color magenta100 = Color(0xffffbddd);
  static const Color magenta200 = Color(0xffffa7d1);
  static const Color magenta300 = Color(0xffff9ccc);
  static const Color magenta400 = Color(0xffff87c0);
  static const Color magenta500 = Color(0xffff7cbb);
  static const Color magenta600 = Color(0xffff5ba9);
  static const Color magenta700 = Color(0xffff459e);
  static const Color magenta800 = Color(0xffff248d);
  static const Color violet100 = Color(0xff8987ff);
  static const Color violet200 = Color(0xff7f7cff);
  static const Color violet300 = Color(0xff7471ff);
  static const Color violet400 = Color(0xff6966ff);
  static const Color violet500 = Color(0xff615dff);
  static const Color violet600 = Color(0xff5450ff);
  static const Color violet700 = Color(0xff3e3aff);
  static const Color violet800 = Color(0xff2924ff);

  static List<Color> generalTabColorList = [
    teal200,
    teal300,
    teal400,
    teal500,
    magenta200,
    magenta300,
    magenta400,
    magenta500,
    violet200,
    violet300,
    violet400,
    violet500
  ];

  Color getRandomColor() {
    final random = Random();
    int index1 = random.nextInt(generalTabColorList.length);
    return generalTabColorList[index1];
  }
}

class FontFamily {
  static const String shadowsIntoLightTwo = 'ShadowsIntoLightTwo';
}

class FontSize {
  static const double regular = 18;
  static const double small = 16.5;
  static const double large = 36;
  static const double main96 = 96;
  static const double main64 = 64;
  static const double main48 = 48;
  static const double main36 = 36;
  static const double main24 = 24;
  static const double main16 = 16;
  static const double main14 = 14;
  static const double main12 = 12;
  static const double main10 = 10;
  static const double display96 = 96;
  static const double display64 = 64;
  static const double display48 = 48;
  static const double display36 = 36;
  static const double display24 = 24;
  static const double display16 = 16;
  
}

