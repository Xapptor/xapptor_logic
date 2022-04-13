int find_first_letter_index({
  required String text,
  int index = 0,
}) {
  int current_index = 0;
  List<String> chars =
      text.runes.map((rune) => String.fromCharCode(rune)).toList();

  int found_counter = 0;

  chars.forEach((char) {
    int? char_parsed = int.tryParse(char);
    if (char_parsed == null) {
      if (found_counter <= index) {
        current_index = chars.indexOf(char);
        found_counter++;
      }
    }
  });

  return current_index;
}
