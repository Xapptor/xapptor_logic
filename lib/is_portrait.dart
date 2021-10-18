import 'package:flutter/material.dart';

// Check if is portrait mode.

bool is_portrait(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}
