import 'dart:typed_data';
import 'package:http/http.dart';

Future<Uint8List> get_temporary_svg_file(String url) async {
  var response = await get(Uri.parse(url));
  Uint8List? bytes = response.bodyBytes;
  return bytes;
}
