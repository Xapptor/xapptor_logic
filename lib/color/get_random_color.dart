import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xapptor_logic/random/random_number_with_range.dart';

Color get_random_color({
  required Color? seed_color,
  int color_difference = 50,
}) {
  Color random_color = Colors.white;

  if (seed_color != null) {
    int random_number_for_red = random_number_with_range(-color_difference, color_difference).clamp(0, 255);
    int random_red = (seed_color.r + random_number_for_red) as int;

    int random_number_for_green = random_number_with_range(-color_difference, color_difference).clamp(0, 255);
    int random_green = (seed_color.g + random_number_for_green) as int;

    int random_number_for_blue = random_number_with_range(-color_difference, color_difference).clamp(0, 255);
    int random_blue = (seed_color.b + random_number_for_blue) as int;

    random_color = Color.fromRGBO(random_red, random_green, random_blue, 1);
  } else {
    random_color = Color((Random().nextDouble() * 0xFFFFFF).toInt());
  }
  return random_color;
}
