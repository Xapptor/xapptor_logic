import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:xapptor_logic/random/random_number_with_range.dart';

// DUPLICATE

// Duplicate document.

duplicate_document({
  required String document_id,
  required String collection_id,
  required int times,
  String? base_id,
  required bool apply_random_number,
  Map<String, dynamic>? add_values,
  Map<String, dynamic>? update_values,
}) async {
  CollectionReference<Map<String, dynamic>> collection_reference = FirebaseFirestore.instance.collection(collection_id);

  await FirebaseFirestore.instance.collection(collection_id).doc(document_id).get().then((document_snapshot) {
    if (document_snapshot.data() != null) {
      for (var i = 0; i < times; i++) {
        Map<String, dynamic> new_data = document_snapshot.data()!;

        if (add_values != null) {
          add_values.forEach((key, value) {
            new_data[key] = value;
          });
        }

        if (update_values != null) {
          update_values.forEach((key, value) {
            if (new_data[key] != null) {
              new_data[key] = value;
            }
          });
        }

        if (base_id != null) {
          String counter = times == 1 ? "" : "_${i + 1}";

          if (apply_random_number) {
            int random_numer_1 = random_number_with_range(0, 9);
            int random_numer_2 = random_number_with_range(0, 9);
            int random_numer_3 = random_number_with_range(0, 9);
            int random_numer_4 = random_number_with_range(0, 9);

            String random_numer = "$random_numer_1$random_numer_2$random_numer_3$random_numer_4";

            counter = "_$random_numer$counter";
          }

          String doc_name = "$base_id$counter";
          debugPrint(doc_name);

          collection_reference.doc(doc_name).set(new_data);
        } else {
          collection_reference.add(new_data);
        }
      }
    }
  });
}

// Duplicate item in array.

duplicate_item_in_array({
  required String document_id,
  required String collection_id,
  required String field_key,
  required int index,
  required int times,
  required Function callback,
}) async {
  await FirebaseFirestore.instance.collection(collection_id).doc(document_id).get().then((document_snapshot) {
    Map<String, dynamic> original_field_value = document_snapshot.data()![field_key][index];

    List new_array = document_snapshot.data()![field_key];

    for (var i = 0; i < times; i++) {
      new_array.add(original_field_value);
    }

    document_snapshot.reference.update({field_key: new_array});

    callback();
  });
}