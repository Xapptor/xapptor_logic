import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Open Share Dialog.

class FileDownloader {
  FileDownloader._();

  static Future save({
    required String src, // Source could be Base64 or Url
    required String file_name,
  }) async {
    Uint8List bytes = base64.decode(src);
    final directory = await getTemporaryDirectory();
    String file_path = "${directory.path}/$file_name";

    final file = File(file_path);
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file_path)]);
  }
}
