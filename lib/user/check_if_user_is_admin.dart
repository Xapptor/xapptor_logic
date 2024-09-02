import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<bool> check_if_user_is_admin(String? user_id) async {
  String id = user_id ?? FirebaseAuth.instance.currentUser?.uid ?? '';

  if (user_id != '') {
    DocumentSnapshot user = await XapptorDB.instance.collection("users").doc(id).get();

    Map user_data = user.data() as Map;
    if (user_data["admin"] != null) {
      return user_data["admin"];
    } else {
      return false;
    }
  } else {
    return false;
  }
}
