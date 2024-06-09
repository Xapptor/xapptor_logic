import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color> get_main_color_from_image(Image image) async {
  PaletteGenerator palette_generator = await PaletteGenerator.fromImageProvider(image.image);
  return palette_generator.dominantColor!.color;
}
