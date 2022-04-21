import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xapptor_logic/random_number_with_range.dart';

Color get_random_color({
  required Color? seed_color,
  int color_difference = 50,
}) {
  Color random_color = Colors.white;

  if (seed_color != null) {
    int random_red = seed_color.red +
        random_number_with_range(-color_difference, color_difference)
            .clamp(0, 255);

    int random_green = seed_color.green +
        random_number_with_range(-color_difference, color_difference)
            .clamp(0, 255);

    int random_blue = seed_color.blue +
        random_number_with_range(-color_difference, color_difference)
            .clamp(0, 255);

    random_color = Color.fromRGBO(random_red, random_green, random_blue, 1);
  } else {
    random_color = Color((Random().nextDouble() * 0xFFFFFF).toInt());
  }
  return random_color;
}
