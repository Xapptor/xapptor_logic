import 'package:flutter/material.dart';

bool is_portrait(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}
