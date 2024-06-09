enum TextPriority {
  low,
  medium,
  high,
  urgent,
}

String change_color_by_priority(String text, TextPriority text_priority) {
  String color_code = "35";

  if (text_priority == TextPriority.medium) {
    color_code = "32";
  } else if (text_priority == TextPriority.high) {
    color_code = "33";
  } else if (text_priority == TextPriority.urgent) {
    color_code = "31";
  }
  return "\x1B[${color_code}m$text\x1B[0m";
}
