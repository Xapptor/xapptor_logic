import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_logic/models/coupon.dart';
import 'package:xapptor_logic/random_number_with_range.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'file_downloader/file_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';

int collection_counter = 0;

print_collection_counter() {
  debugPrint("collection_counter $collection_counter");
}

// CREATE

// Create coupons.

create_coupons({
  required int times,
  String? base_id,
  Map<String, dynamic>? add_values,
  Map<String, dynamic>? update_values,
}) {
  duplicate_document(
    document_id: "template",
    collection_id: "coupons",
    times: times,
    base_id: "${base_id}_d_${DateFormat('dd_MM_yy').format(DateTime.now())}",
    apply_random_number: true,
    add_values: add_values,
    update_values: update_values,
  );
}

// UPDATE

// Update field value in collection.

update_field_value_in_collection({
  required String field,
  required dynamic value,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot = await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    document.reference.update({field: value});
    collection_counter++;
  }
  print_collection_counter();
}

// Update field name in collection.

update_field_name_in_collection({
  required String collection,
  required String old_field,
  required String new_field,
}) async {
  QuerySnapshot collection_snapshot = await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    update_field_name_in_document(
      collection: collection,
      document: document,
      old_field: old_field,
      new_field: new_field,
    );
    collection_counter++;
  }
  print_collection_counter();
}

// Update field name in document.

update_field_name_in_document({
  required String collection,
  DocumentSnapshot? document,
  String? document_id,
  required String old_field,
  required String new_field,
}) async {
  document ??= await FirebaseFirestore.instance.collection(collection).doc(document_id).get();
  document.reference.update({old_field: FieldValue.delete(), new_field: document.get(old_field)});
}

// Update item value in array.

update_item_value_in_array({
  required String document_id,
  required String collection_id,
  required String field_key,
  required dynamic field_value,
  required int index,
}) async {
  await FirebaseFirestore.instance.collection(collection_id).doc(document_id).get().then((document_snapshot) {
    List original_array = document_snapshot.data()![field_key];
    original_array[index] = field_value;

    document_snapshot.reference.update({field_key: original_array});
  });
}

// Update users gender.

update_users_gender() async {
  await FirebaseFirestore.instance.collection("users").get().then((collection) {
    for (var user in collection.docs) {
      var user_data = user.data();
      String user_gender = user_data["gender"].toLowerCase();

      if (user_gender == "male" || user_gender == "hombre") {
        user.reference.update({"gender": 0});
      } else if (user_gender == "female" || user_gender == "mujer") {
        user.reference.update({"gender": 1});
      } else if (user_gender == "non binary" || user_gender == "no binario") {
        user.reference.update({"gender": 2});
      } else if (user_gender == "rather not say" || user_gender == "prefiero no decir") {
        user.reference.update({"gender": 3});
      }

      collection_counter++;
    }

    print_collection_counter();
  });
}

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

// DELETE

// Delete field in collection.

delete_field_in_collection({
  required String field,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot = await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    document.reference.update({field: FieldValue.delete()});
    collection_counter++;
  }
  print_collection_counter();
}

// Delete corrupted accounts.

delete_corrupted_accounts() async {
  await FirebaseFirestore.instance.collection("users").get().then((collection) {
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

  await FirebaseFirestore.instance.collection("certificates").get().then((collection) async {
    for (var certificate in collection.docs) {
      certificates_counter++;

      var certificate_data = certificate.data();
      DocumentSnapshot user =
          await FirebaseFirestore.instance.collection("users").doc(certificate_data["user_id"]).get();
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
  QuerySnapshot collection_snapshot = await FirebaseFirestore.instance.collection(collection).get();

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
  QuerySnapshot collection_snapshot = await FirebaseFirestore.instance.collection(collection).get();

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

// CHECK

// Check if coupon is valid.

Future<String> check_if_coupon_is_valid(
  String coupon_id,
  BuildContext context,
  String valid_message,
  String invalid_message,
) async {
  String? user_id = FirebaseAuth.instance.currentUser?.uid;
  bool coupon_is_valid = false;

  if (user_id == null) return "login";

  DocumentSnapshot coupon_snapshot = await FirebaseFirestore.instance.collection("coupons").doc(coupon_id).get();

  if (coupon_snapshot.exists) {
    Coupon coupon = Coupon.from_snapshot(
      coupon_snapshot.id,
      coupon_snapshot.data() as Map<String, dynamic>,
    );

    if (coupon.user_id.isEmpty || coupon.user_id == user_id) {
      int date_difference = coupon.date_expiry.compareTo(DateTime.now());
      if (!coupon.used) {
        if (date_difference > 0) {
          coupon_is_valid = true;

          await coupon_snapshot.reference.update({
            "used": true,
            "user_id": user_id,
            "date_used": FieldValue.serverTimestamp(),
          });

          await FirebaseFirestore.instance.collection("users").doc(user_id).update({
            "products_acquired": FieldValue.arrayUnion([coupon.product_id]),
          });
        }
      }
    }
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          coupon_is_valid ? valid_message : invalid_message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Icon(
          coupon_is_valid ? Icons.check_circle_rounded : Icons.info,
          color: Colors.white,
        ),
        backgroundColor: coupon_is_valid ? Colors.green : Colors.red,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
          ),
        ],
      ),
    );
  }

  await Future.delayed(const Duration(milliseconds: 2300));
  if (context.mounted) ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  return coupon_is_valid ? "home/courses" : "";
}

// GET

// Get coupons usage info.

get_coupons_usage_info(
  Timestamp date_created,
) async {
  QuerySnapshot coupon_query_snapshot =
      await FirebaseFirestore.instance.collection("coupons").where("date_created", isEqualTo: date_created).get();

  List<DocumentSnapshot> coupon_query_snapshot_docs = coupon_query_snapshot.docs;

  List<Coupon> coupons = [];
  List<String> name_list = [];
  List<String> course_was_completed_list = [];

  coupon_query_snapshot_docs.removeWhere((element) => element.id == "template");

  for (var element in coupon_query_snapshot_docs) {
    Coupon coupon = Coupon.from_snapshot(
      element.id,
      element.data() as Map<String, dynamic>,
    );

    coupons.add(coupon);

    if (coupon.user_id != "") {
      DocumentSnapshot user_snap = await FirebaseFirestore.instance.collection("users").doc(coupon.user_id).get();

      Map user_data = user_snap.data() as Map<String, dynamic>;

      String fullname = user_data["firstname"] + " " + user_data["lastname"];

      debugPrint("user_data -------------");
      debugPrint(fullname);

      name_list.add(fullname);

      bool course_was_completed = false;

      if (user_data["units_completed"] != null) {
        course_was_completed = (user_data["units_completed"] as List).length >= 4;
      }

      course_was_completed_list.add(course_was_completed ? "Yes" : "No");
    } else {
      name_list.add("");
      course_was_completed_list.add("");
    }
  }

  Timer(const Duration(seconds: 3), () {
    debugPrint(coupons.length.toString());
    debugPrint(name_list.length.toString());
    debugPrint(course_was_completed_list.length.toString());

    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName("A1").setText("Coupon ID");
    sheet.getRangeByName("B1").setText("Used by");
    sheet.getRangeByName("C1").setText("The course was completed");

    for (var i = 0; i < coupons.length; i++) {
      sheet.getRangeByName("A${i + 2}").setText(coupons[i].id);
      sheet.getRangeByName("B${i + 2}").setText(name_list[i]);
      sheet.getRangeByName("C${i + 2}").setText(course_was_completed_list[i]);
    }

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);

    String file_name = "coupons_usage_info_${date_created.toDate()}.xlsx";
    file_name = file_name.replaceAll(":", "_").replaceAll("-", "_").replaceAll(" ", "_").replaceFirst(".", "_");

    FileDownloader.save(
      src: base64Encode(workbook.saveAsStream()),
      file_name: file_name,
    );
    workbook.dispose();
  });
}

// Firebase Storage

// Save temporary File

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
