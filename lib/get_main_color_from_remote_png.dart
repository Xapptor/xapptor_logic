import 'package:flutter/material.dart';
import 'get_main_color_from_local_image.dart';
import 'get_widget_image_from_remote_png.dart';

get_main_color_from_remote_png(String url) async {
  Image image = await get_widget_image_from_remote_png(url);
  Color main_color = await get_main_color_from_local_image(image);
  return main_color;
}
