import 'package:flutter/material.dart';
import 'get_remote_svg.dart';

Future<Color> get_main_color_from_remote_svg(String url) async {
  String svg_string = await get_remote_svg(url);
  int svg_string_color_index = svg_string.indexOf("#");

  String svg_string_color = "0xff" +
      svg_string.substring(
          svg_string_color_index + 1, svg_string_color_index + 7);
  return Color(int.parse(svg_string_color));
}
