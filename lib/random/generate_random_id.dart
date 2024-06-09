import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:xapptor_logic/string/add_separator_to_string.dart';

String generate_random_id({
  bool use_separators = true,
}) {
  final now = DateTime.now();
  Random random = Random();

  String epoch = (now.millisecondsSinceEpoch + now.microsecondsSinceEpoch).toString();

  int half_length = (epoch.length / 2).floor();

  String string_1 = epoch.substring(0, half_length);
  String string_2 = epoch.substring(half_length, epoch.length);

  String numbers_to_numbers = "";
  for (int i = 0; i < string_1.length; i++) {
    int number = int.parse(string_1.characters.toList()[i]);

    String added_number = (number + random.nextInt(5)).clamp(0, 9).toString();
    numbers_to_numbers += added_number;
  }

  String numbers_to_chars = "";
  for (int i = 0; i < string_2.length; i++) {
    int number = int.parse(string_2.characters.toList()[i]);

    int added_number = number + 65 + random.nextInt(5);
    numbers_to_chars += String.fromCharCode(number + added_number);
  }

  List<String> final_string_array = epoch.characters.toList();

  for (int i = 0; i < epoch.length - 1; i++) {
    int current_index = (i / 2).floor();

    if (i % 2 == 0) {
      final_string_array[i] = numbers_to_numbers[current_index];
    } else {
      final_string_array[i] = numbers_to_chars[current_index];
    }
  }

  int epoch_char_1 = int.parse(epoch.characters.toList()[0]);
  int epoch_char_2 = int.parse(epoch.characters.toList()[epoch.length ~/ 2]);
  int epoch_char_3 = int.parse(epoch.characters.toList()[epoch.length - 1]);

  int random_n_1 = random.nextInt(epoch_char_1.clamp(1, 9));
  int random_n_2 = random.nextInt(epoch_char_2.clamp(1, 9));
  int random_n_3 = random.nextInt(epoch_char_3.clamp(1, 9));

  String separator_1 = String.fromCharCode(random_n_1 + 33);
  String separator_2 = String.fromCharCode(random_n_2 + 33);
  String separator_3 = String.fromCharCode(random_n_3 + 33);
  List<String> separators = [separator_1, separator_2, separator_3];

  String final_string = use_separators
      ? add_separator_to_string(
          string: final_string_array.join(),
          separators: separators,
          interval: 4,
        )
      : final_string_array.join();

  return final_string;
}
