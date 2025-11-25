import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<Size> get_video_size({
  required VideoPlayerController controller,
}) async {
  // Ensure the video is initialized before reading properties
  if (!controller.value.isInitialized) {
    await controller.initialize();
  }

  // controller.value.size is already a Size(width, height)
  return controller.value.size;
}

Future<bool> check_if_video_is_square({
  required VideoPlayerController controller,
}) async {
  Size video_size = await get_video_size(controller: controller);

  double height_divided_by_width = (video_size.height / video_size.width).abs();

  // Same 1–1.1 tolerance you used for images
  bool video_is_square = height_divided_by_width >= 1 && height_divided_by_width <= 1.1;

  return video_is_square;
}
