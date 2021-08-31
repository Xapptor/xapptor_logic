import 'package:cloud_firestore/cloud_firestore.dart';

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

update_field_in_collection({
  required String field,
  required dynamic value,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot =
      await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    document.reference.update({field: value});
  }
}

delete_field_in_collection({
  required String field,
  required String collection,
}) async {
  QuerySnapshot collection_snapshot =
      await FirebaseFirestore.instance.collection(collection).get();

  for (var document in collection_snapshot.docs) {
    document.reference.update({field: FieldValue.delete()});
  }
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
