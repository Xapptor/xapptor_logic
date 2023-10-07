String get_file_extension_from_url(String url) {
  String file_extension = url.split('.').last;
  if (file_extension.contains("?")) {
    file_extension = file_extension.split('?').first;
  }
  return file_extension;
}
