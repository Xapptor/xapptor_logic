// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html';

class FileDownloader {
  FileDownloader._();

  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future clean_temp_files() async {
    ListResult temp_files = await storage.ref("temp").listAll();
    for (Reference ref in temp_files.items) {
      await ref.delete();
    }
  }

  static Future save({
    required src, // Source could be Bytes or Url
    required String file_name,
    Function? callback,
  }) async {
    await clean_temp_files();
    if (src is String) {
      if (src.contains("http")) {
        _download(
          src: src,
          file_name: file_name,
          callback: callback,
        );
      }
    } else if (src is Uint8List) {
      Reference temp_file = storage.ref("temp/$file_name");
      await temp_file.putData(src);
      _download(
        src: await temp_file.getDownloadURL(),
        file_name: file_name,
        callback: callback,
      );
    }
  }

  static Future _download({
    required String src,
    required String file_name,
    required Function? callback,
  }) async {
    final anchor = AnchorElement(
      href: src,
    );
    anchor.setAttribute(
      "download",
      file_name,
    );
    anchor.download = src;
    anchor.click();
    anchor.remove();
    if (callback != null) callback();
  }
}
