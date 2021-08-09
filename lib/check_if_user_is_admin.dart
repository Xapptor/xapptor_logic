import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> check_if_user_is_admin(user_id) async {
  DocumentSnapshot user =
      await FirebaseFirestore.instance.collection("users").doc(user_id).get();
  return user.get("admin") != null && user.get("admin");
}
