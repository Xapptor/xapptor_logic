import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'get_remote_svg.dart';

Future<Color> get_main_color_from_remote_svg(String url) async {
  Uint8List remote_svg_bytes = await get_remote_svg(url);

  final directory = await getTemporaryDirectory();
  String file_path = directory.path + "/temporary.svg";

  File file = File(file_path);
  await file.writeAsBytes(remote_svg_bytes);

  String svg_string = await file.readAsString();
  int svg_string_color_index = svg_string.indexOf("#");

  String svg_string_color = "0xff" +
      svg_string.substring(
          svg_string_color_index + 1, svg_string_color_index + 7);
  return Color(int.parse(svg_string_color));
}
