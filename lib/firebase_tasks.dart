import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_logic/models/coupon.dart';
import 'package:xapptor_router/app_screens.dart';

int collection_counter = 0;

print_collection_counter() {
  print("collection_counter $collection_counter");
}

// UPDATE

update_field_in_collection({
  required String field,
  required dynamic value,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot =
      await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    document.reference.update({field: value});
    collection_counter++;
  }
  print_collection_counter();
}

update_field_name_in_collection({
  required String collection,
  required String old_field,
  required String new_field,
}) async {
  QuerySnapshot collection_snapshot =
      await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    //if (document.id == "IW1ZHfPPRRY6L6U1VHsii66grzY2") {
    update_field_name_in_document(
      collection: collection,
      document: document,
      old_field: old_field,
      new_field: new_field,
    );
    //}
    collection_counter++;
  }
  print_collection_counter();
}

update_field_name_in_document({
  required String collection,
  DocumentSnapshot? document,
  String? document_id,
  required String old_field,
  required String new_field,
}) async {
  if (document == null) {
    document = await FirebaseFirestore.instance
        .collection(collection)
        .doc(document_id)
        .get();
  }
  document.reference.update(
      {old_field: FieldValue.delete(), new_field: document.get(old_field)});
}

update_item_in_array_field({
  required String document_id,
  required String collection_id,
  required String field_key,
  required dynamic field_value,
  required int index,
}) async {
  await FirebaseFirestore.instance
      .collection(collection_id)
      .doc(document_id)
      .get()
      .then((document_snapshot) {
    List original_array = document_snapshot.data()![field_key];
    original_array[index] = field_value;

    document_snapshot.reference.update({field_key: original_array});
  });
}

// DUPLICATE

duplicate_document({
  required String document_id,
  required String collection_id,
  required int times,
}) async {
  CollectionReference<Map<String, dynamic>> collection_reference =
      FirebaseFirestore.instance.collection(collection_id);

  await FirebaseFirestore.instance
      .collection(collection_id)
      .doc(document_id)
      .get()
      .then((document_snapshot) {
    if (document_snapshot.data() != null) {
      for (var i = 0; i < times; i++) {
        collection_reference.add(document_snapshot.data()!);
      }
    }
  });
}

duplicate_item_in_array_field({
  required String document_id,
  required String collection_id,
  required String field_key,
  required int index,
  required int times,
  required Function callback,
}) async {
  await FirebaseFirestore.instance
      .collection(collection_id)
      .doc(document_id)
      .get()
      .then((document_snapshot) {
    Map<String, dynamic> original_field_value =
        document_snapshot.data()![field_key][index];

    List original_array = document_snapshot.data()![field_key];

    for (var i = 0; i < times; i++) {
      original_array.add(original_field_value);
    }

    document_snapshot.reference.update({field_key: original_array});

    callback();
  });
}

// DELETE

delete_field_in_collection({
  required String field,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot =
      await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    document.reference.update({field: FieldValue.delete()});
    collection_counter++;
  }
  print_collection_counter();
}

delete_corrupted_accounts() async {
  await FirebaseFirestore.instance.collection("users").get().then((collection) {
    collection.docs.forEach((user) {
      var user_data = user.data();
      if (user_data["gender"] == null &&
          user_data["birthday"] == null &&
          user_data["country"] == null) {
        print("id: ${user.id} user_data $user_data");
        user.reference.delete();
      }
      collection_counter++;
    });
    print_collection_counter();
  });
}

// ABEINSTITUTE

delete_corrupted_certificates() async {
  int certificates_counter = 0;
  int certificates_corrupted_counter = 0;

  await FirebaseFirestore.instance
      .collection("certificates")
      .get()
      .then((collection) {
    collection.docs.forEach((certificate) async {
      certificates_counter++;

      var certificate_data = certificate.data();
      DocumentSnapshot user = await FirebaseFirestore.instance
          .collection("users")
          .doc(certificate_data["user_id"])
          .get();
      if (!user.exists) {
        certificates_corrupted_counter++;
        print("id: ${certificate.id} user_id: ${certificate_data["user_id"]}");
        certificate.reference.delete();
      }
    });

    Timer(Duration(milliseconds: 800), () {
      print("certificates_counter $certificates_counter");
      print("certificates_corrupted_counter $certificates_corrupted_counter");
    });
  });
}

// USER GENDER

update_users_gender_value() async {
  await FirebaseFirestore.instance.collection("users").get().then((collection) {
    collection.docs.forEach((user) async {
      var user_data = user.data();
      String user_gender = user_data["gender"].toLowerCase();

      if (user_gender == "male" || user_gender == "hombre") {
        user.reference.update({"gender": 0});
      } else if (user_gender == "female" || user_gender == "mujer") {
        user.reference.update({"gender": 1});
      } else if (user_gender == "non-binary" || user_gender == "no-binario") {
        user.reference.update({"gender": 2});
      } else if (user_gender == "rather not say" ||
          user_gender == "prefiero no decir") {
        user.reference.update({"gender": 3});
      }

      collection_counter++;
    });

    print_collection_counter();
  });
}

// COUPONS

Future<bool> check_if_coupon_is_valid(
  String coupon_id,
  BuildContext context,
  String valid_message,
  String invalid_message,
) async {
  String? user_id = FirebaseAuth.instance.currentUser?.uid;
  bool coupon_is_valid = false;

  DocumentSnapshot coupon_snapshot = await FirebaseFirestore.instance
      .collection("coupons")
      .doc(coupon_id)
      .get();
  if (coupon_snapshot.exists) {
    Coupon coupon = Coupon.from_snapshot(
      coupon_snapshot.id,
      coupon_snapshot.data() as Map<String, dynamic>,
    );
    if (user_id != null) {
      if (coupon.user_id == user_id) {
        int date_diference = coupon.date_expiry.compareTo(DateTime.now());
        if (!coupon.used) {
          if (date_diference > 0) {
            await coupon_snapshot.reference.update({"used": true});
            coupon_is_valid = true;

            await FirebaseFirestore.instance
                .collection("users")
                .doc(user_id)
                .update({
              "courses_acquired": FieldValue.arrayUnion([coupon.product_id]),
            });
            open_screen("home/courses");
          }
        }
      }
    }
  }

  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: Text(
        coupon_is_valid ? valid_message : invalid_message,
        style: TextStyle(
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

  Timer(
    Duration(seconds: coupon_is_valid ? 2 : 1),
    () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    },
  );

  return coupon_is_valid;
}
