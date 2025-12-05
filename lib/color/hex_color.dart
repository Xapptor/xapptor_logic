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

  /// Prefixes a hash sign if [leading_hash_sign] is set to `true` (default is `true`).
  String toHex({bool leading_hash_sign = true}) {
    final alpha_int = (a * 255).round().clamp(0, 255);
    final red_int = (r * 255).round().clamp(0, 255);
    final green_int = (g * 255).round().clamp(0, 255);
    final blue_int = (b * 255).round().clamp(0, 255);

    return '${leading_hash_sign ? '#' : ''}'
        '${alpha_int.toRadixString(16).padLeft(2, '0')}'
        '${red_int.toRadixString(16).padLeft(2, '0')}'
        '${green_int.toRadixString(16).padLeft(2, '0')}'
        '${blue_int.toRadixString(16).padLeft(2, '0')}';
  }
}
