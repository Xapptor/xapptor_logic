import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Uint8List> get_bytes_from_remote_image(String src) async {
  http.Response response = await http.get(
    Uri.parse(src),
  );
  return response.bodyBytes;
}

Future<String> get_base64_from_remote_image(String src) async {
  return base64.encode(await get_bytes_from_remote_image(src));
}
