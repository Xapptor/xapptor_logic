import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color> get_main_color_from_local_image(Image image) async {
  PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(image.image);
  return paletteGenerator.dominantColor!.color;
}
