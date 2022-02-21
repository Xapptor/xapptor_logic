String get_file_extension_from_url(String url) {
  String extension = url.split('.').last;
  if (extension.contains("?")) {
    extension = extension.split('?').first;
  }
  return extension;
}
