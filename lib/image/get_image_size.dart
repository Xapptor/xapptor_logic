import 'dart:async';
import 'package:flutter/material.dart';

Future<Size> get_image_size({
  required Image image,
}) async {
  Completer<Size> completer = Completer();

  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        var myImage = image.image;
        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(size);
      },
    ),
  );
  return completer.future;
}

Future<bool> check_if_image_is_square({
  required Image image,
}) async {
  Size image_size = await get_image_size(image: image);
  double height_divided_by_width = (image_size.height / image_size.width).abs();
  bool image_is_square = height_divided_by_width >= 1 && height_divided_by_width <= 1.1;
  return image_is_square;
}
