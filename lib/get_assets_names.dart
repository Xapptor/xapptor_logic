import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<String>> get_assets_names({
  required List<String> filter_keys,
}) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  final Map<String, dynamic> manifest_map = json.decode(manifestContent);

  List<String> image_paths = [];

  filter_keys.forEach((filter_key) {
    image_paths += manifest_map.keys
        .where(
            (String manifest_map_key) => manifest_map_key.contains(filter_key))
        .toList();
  });

  return image_paths;
}
