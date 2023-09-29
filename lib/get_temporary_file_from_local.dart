import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<File> get_temporary_file_from_local({
  required Uint8List bytes,
  required String name,
}) async {
  final directory = await getTemporaryDirectory();
  File file = await File("${directory.path}/$name").writeAsBytes(bytes);
  return file;
}
