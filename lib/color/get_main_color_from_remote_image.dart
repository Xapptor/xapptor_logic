import 'package:flutter/material.dart';
import 'get_main_color_from_image.dart';
import 'package:xapptor_logic/image/get_remote_image.dart';

Future<Color> get_main_color_from_remote_image(String url) async {
  Image image = await get_remote_image(url);
  Color main_color = await get_main_color_from_image(image);
  return main_color;
}
