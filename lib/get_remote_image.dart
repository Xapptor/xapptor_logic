import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// Get remote image.

Future<Image> get_remote_image(String url) async {
  var response = await get(Uri.parse(url));
  Uint8List? bytes = response.bodyBytes;
  return Image.memory(bytes);
}
