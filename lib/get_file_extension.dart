String get_file_extension(String file_name) {
  String extension = file_name.split('.').last;
  if (extension.contains("?")) {
    extension = extension.split('?').first;
  }
  print("extension");
  print(extension);
  return extension;
}
