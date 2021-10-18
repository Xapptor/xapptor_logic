import 'package:cloud_firestore/cloud_firestore.dart';

// Check if the user is admin.
// Search param in user document of Firebase Firestore.

Future<bool> check_if_user_is_admin(user_id) async {
  DocumentSnapshot user =
      await FirebaseFirestore.instance.collection("users").doc(user_id).get();

  Map user_data = user.data() as Map;
  if (user_data["admin"] != null) {
    return user_data["admin"];
  } else {
    return false;
  }
}
