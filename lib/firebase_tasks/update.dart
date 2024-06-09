import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_logic/firebase_tasks/collection_counter.dart';

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
