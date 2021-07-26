import 'dart:html';

class FileDownloader {
  FileDownloader._();

  static save(String base64_string, String file_name) {
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
