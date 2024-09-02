import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:xapptor_logic/firebase_tasks/collection_counter.dart';
import 'dart:async';
import 'package:xapptor_db/xapptor_db.dart';

// DELETE

// Delete field in collection.

delete_field_in_collection({
  required String field,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot = await XapptorDB.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    document.reference.update({field: FieldValue.delete()});
    collection_counter++;
  }
  print_collection_counter();
}

// Delete corrupted accounts.

delete_corrupted_accounts() async {
  await XapptorDB.instance.collection("users").get().then((collection) {
    for (var user in collection.docs) {
      var user_data = user.data();
      if (user_data["gender"] == null && user_data["birthday"] == null && user_data["country"] == null) {
        debugPrint("id: ${user.id} user_data $user_data");
        user.reference.delete();
      }
      collection_counter++;
    }
    print_collection_counter();
  });
}

// Delete corrupted certificates.

delete_corrupted_certificates() async {
  int certificates_counter = 0;
  int certificates_corrupted_counter = 0;

  await XapptorDB.instance.collection("certificates").get().then((collection) async {
    for (var certificate in collection.docs) {
      certificates_counter++;

      var certificate_data = certificate.data();
      DocumentSnapshot user = await XapptorDB.instance.collection("users").doc(certificate_data["user_id"]).get();
      if (!user.exists) {
        certificates_corrupted_counter++;
        debugPrint("id: ${certificate.id} user_id: ${certificate_data["user_id"]}");
        certificate.reference.delete();
      }
    }

    Timer(const Duration(milliseconds: 800), () {
      debugPrint("certificates_counter $certificates_counter");
      debugPrint("certificates_corrupted_counter $certificates_corrupted_counter");
    });
  });
}

// Delete documents that contains id similar to.

delete_documents_that_contains_id_similar_to({
  required String id,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot = await XapptorDB.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    if (document.id.contains(id)) {
      document.reference.delete();
      collection_counter++;
    }
  }
  print_collection_counter();
}

// Delete documents that contains a field with a value similar to.

delete_documents_that_contains_field_with_value_similar_to({
  required String field,
  required String value,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot = await XapptorDB.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    Map doc_data = document.data() as Map;
    if (doc_data[field].toString().contains(value)) {
      document.reference.delete();
      collection_counter++;
    }
  }
  print_collection_counter();
}

// Delete all files in a path

delete_all_files_in_a_path({
  required String path,
}) async {
  ListResult folder_ref = await FirebaseStorage.instance.ref(path).listAll();
  for (var item in folder_ref.items) {
    item.delete();
  }

  for (var prefix in folder_ref.prefixes) {
    delete_all_files_in_a_path(path: prefix.fullPath);
  }
}

// Delete coupons from a date.

Future<void> delete_coupons_from_a_date({
  required DateTime from_date,
}) async {
  DateTime start_date = DateTime(from_date.year, from_date.month, from_date.day);
  DateTime end_date = DateTime(from_date.year, from_date.month, from_date.day, 23, 59, 59);

  await XapptorDB.instance
      .collection("coupons")
      .where("date_created", isGreaterThanOrEqualTo: start_date)
      .where("date_created", isLessThanOrEqualTo: end_date)
      .get()
      .then((collection) {
    for (var coupon in collection.docs) {
      coupon.reference.delete();
      collection_counter++;
    }
    print_collection_counter();
  });
}

// Delete coupons generated today.

Future<void> delete_coupons_generated_today() async {
  await delete_coupons_from_a_date(from_date: DateTime.now());
}
