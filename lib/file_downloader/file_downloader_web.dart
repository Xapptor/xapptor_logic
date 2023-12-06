// ignore_for_file: avoid_web_libraries_in_flutter

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
    // Source could be Base64 or Url
    required String src,
    required String file_name,
  }) async {
    await clean_temp_files();
    if (src.contains("http")) {
      _download(
        src: src,
        file_name: file_name,
      );
    } else {
      Reference temp_file = storage.ref("temp/$file_name");
      await temp_file.putString(src);
      String download_url = await temp_file.getDownloadURL();

      _download(
        src: download_url,
        file_name: file_name,
      );
    }
  }

  static Future _download({
    required String src,
    required String file_name,
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
  }
}
