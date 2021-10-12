import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileDownloader {
  FileDownloader._();

  static save({
    required String base64_string,
    required String file_name,
  }) async {
    Uint8List bytes = base64.decode(base64_string);
    final directory = await getTemporaryDirectory();
    String file_path = directory.path + "/" + file_name;
    print("filePath: $file_path");
    final file = File(file_path);
    await file.writeAsBytes(bytes);
    Share.shareFiles([file_path]);
  }
}
