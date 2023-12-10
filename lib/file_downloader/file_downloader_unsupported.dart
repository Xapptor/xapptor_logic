class FileDownloader {
  FileDownloader._();

  static Future save({
    required src, // Source could be Bytes or Url
    required String file_name,
    Function? callback,
  }) {
    throw 'Platform Not Supported';
  }
}
