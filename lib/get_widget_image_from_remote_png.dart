import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

Future<Image> get_widget_image_from_remote_png(String url) async {
  var response = await get(Uri.parse(url));
  Uint8List? bytes = response.bodyBytes;
  return Image.memory(bytes);
}
