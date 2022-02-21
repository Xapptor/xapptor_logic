String get_file_name_from_url(String url) {
  String name = url.split('.').first;
  if (name.contains("%2F")) {
    name = name.split('%2F').last;
  }
  return name;
}
