enum TextPriority {
  low,
  medium,
  high,
  urgent,
}

String change_color_by_priority(String text, TextPriority text_priority) {
  String color_code = "";
  switch (text_priority) {
    case TextPriority.low:
      color_code = "35";
    case TextPriority.medium:
      color_code = "32";
    case TextPriority.high:
      color_code = "33";
    case TextPriority.urgent:
      color_code = "31";
  }
  return "\x1B[${color_code}m$text\x1B[0m";
}
