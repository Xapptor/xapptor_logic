import 'dart:html';

// Download file directly.

class FileDownloader {
  FileDownloader._();

  static Future save({
    // Source could be Base64 or Url
    required String src,
    required String file_name,
  }) async {
    if (src.contains("http")) {
      await window.open(src, "_self");
    } else {
      await AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$src",
      )
        ..setAttribute(
          "download",
          file_name,
        )
        ..click();
    }
  }
}
