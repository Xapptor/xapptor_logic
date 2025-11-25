import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Open Share Dialog.

class FileDownloader {
  FileDownloader._();

  static Future save({
    required src, // Source could be Bytes or Url
    required String file_name,
    Function? callback,
  }) async {
    if (src is Uint8List) {
      final directory = await getTemporaryDirectory();
      String file_path = "${directory.path}/$file_name";

      final file = File(file_path);
      await file.writeAsBytes(src);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(file_path),
          ],
        ),
      );

      if (callback != null) callback();
    } else if (src is String) {
      await SharePlus.instance.share(
        ShareParams(
          text: src,
        ),
      );
      if (callback != null) callback();
    }
  }
}
