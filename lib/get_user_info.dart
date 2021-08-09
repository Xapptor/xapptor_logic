import 'package:cloud_firestore/cloud_firestore.dart';

get_user_info(String user_id) async {
  DocumentSnapshot user =
      await FirebaseFirestore.instance.collection("users").doc(user_id).get();
  return user.data();
}
