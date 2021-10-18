import 'dart:convert';
import 'package:http/http.dart';

// Get remote SVG.

Future<String> get_remote_svg(String url) async {
  var response = await get(Uri.parse(url));
  String body = utf8.decode(response.bodyBytes);
  return body;
}
