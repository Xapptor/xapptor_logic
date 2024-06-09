import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

// SAVE

// Save temporary File (Firebase Storage).

Future<String> save_temporary_file({
  required Uint8List bytes,
  required String file_name,
  int temp_minutes_cache = 5,
}) async {
  Reference temp_file_ref = FirebaseStorage.instance.ref("temp/$file_name");
  ListResult temp_folder_ref = await FirebaseStorage.instance.ref("temp").listAll();

  // First delete old files in temp folder

  for (var item in temp_folder_ref.items) {
    FullMetadata item_metadata = await item.getMetadata();
    int minutes_difference = DateTime.now().difference(item_metadata.timeCreated!).inMinutes;

    if (minutes_difference >= temp_minutes_cache) {
      item.delete();
    }
  }

  await temp_file_ref.putData(bytes);
  String url = await temp_file_ref.getDownloadURL();
  return url;
}
