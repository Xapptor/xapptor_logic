import 'package:xapptor_logic/get_base64_from_remote_image.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:xapptor_logic/get_file_extension.dart';

Future<File> get_temporary_file_from_remote_image(String url) async {
  Uint8List bytes = await get_bytes_from_remote_image(url);
  final directory = await getTemporaryDirectory();
  File file = await File(directory.path +
          "/temp_ml_kit_face_detection_image." +
          get_file_extension(url))
      .writeAsBytes(bytes);
  return file;
}
