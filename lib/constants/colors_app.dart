import 'package:flutter/material.dart';

class ColorsApp {
  static Color primary = HexColor.fromHex('#265181');
  static Color primarySecond = HexColor.fromHex('#71bc56');
  static Color black = HexColor.fromHex('#2f2f2f');
}

extension HexColor on Color {
  static Color fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
