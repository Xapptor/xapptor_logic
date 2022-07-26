import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Check if the user is admin.
// Search param in user document of Firebase Firestore.

Future<bool> check_if_user_is_admin(String? user_id) async {
  String id = user_id ?? FirebaseAuth.instance.currentUser?.uid ?? '';

  if (user_id != '') {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

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
