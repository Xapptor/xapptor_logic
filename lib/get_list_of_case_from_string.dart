import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

List<bool> get_list_of_case_from_string(String text) {
  List<bool> list_of_case = [];
  List<String> chars = text.characters.toList();

  for (var char in chars) {
    int index = text.indexOf(char);
    list_of_case.add(!(chars[index].toLowerCase() == chars[index]));
  }
  return list_of_case;
}

String format_string_with_list_of_case(String text, List<bool> list_of_case) {
  List<String> chars = text.characters.toList();
  for (var i = 0; i < chars.length; i++) {
    String char = chars[i];
    chars[i] = list_of_case[i] ? char.toUpperCase() : char.toLowerCase();
  }
  return chars.join();
}
