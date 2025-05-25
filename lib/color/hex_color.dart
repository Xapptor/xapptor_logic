import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');

    buffer.write(hexString.replaceFirst('#', ''));

    return Color(
      int.parse(
        buffer.toString(),
        radix: 16,
      ),
    );
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) {
    final alphaInt = (a * 255).round().clamp(0, 255);
    final redInt = (r * 255).round().clamp(0, 255);
    final greenInt = (g * 255).round().clamp(0, 255);
    final blueInt = (b * 255).round().clamp(0, 255);

    return '${leadingHashSign ? '#' : ''}'
        '${alphaInt.toRadixString(16).padLeft(2, '0')}'
        '${redInt.toRadixString(16).padLeft(2, '0')}'
        '${greenInt.toRadixString(16).padLeft(2, '0')}'
        '${blueInt.toRadixString(16).padLeft(2, '0')}';
  }
}
