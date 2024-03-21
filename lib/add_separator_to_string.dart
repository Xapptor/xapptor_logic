import 'package:characters/characters.dart';

add_separator_to_string({
  required String string,
  required List<String> separators,
  required int interval,
}) {
  List<String> string_list = string.characters.toList();
  int j = 0;
  int k = 0;

  for (int i = 0; i < string.length; i++) {
    if (j == interval) {
      j = 0;

      String separator = "";
      if (separators.length > 1 && k < separators.length) {
        separator = separators[k];
        k++;
      } else {
        separator = separators.last;
      }
      string_list.insert(i, separator);
    } else {
      j++;
    }
  }
  return string_list.join();
}
