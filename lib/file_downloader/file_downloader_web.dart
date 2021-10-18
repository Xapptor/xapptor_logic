import 'dart:html';

// Download file directly.

class FileDownloader {
  FileDownloader._();

  static save({
    required String base64_string,
    required String file_name,
  }) {
    AnchorElement(
      href:
          "data:application/octet-stream;charset=utf-16le;base64,$base64_string",
    )
      ..setAttribute(
        "download",
        file_name,
      )
      ..click();
  }
}
