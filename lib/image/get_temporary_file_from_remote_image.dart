import 'package:xapptor_logic/image/get_data_from_remote_image.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:xapptor_logic/file/get_file_extension_from_url.dart';
import 'package:xapptor_logic/file/get_file_name_from_url.dart';

Future<File> get_temporary_file_from_remote(String url) async {
  Uint8List bytes = await get_bytes_from_remote_image(url);
  final directory = await getTemporaryDirectory();
  String file_name = '${get_file_name_from_url(url)}.${get_file_extension_from_url(url)}';
  String file_path = '${directory.path}/$file_name';
  File file = await File(file_path).writeAsBytes(bytes);
  return file;
}
