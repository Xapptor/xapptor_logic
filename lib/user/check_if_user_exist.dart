import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> check_if_user_exist_by_email({
  required String email,
}) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
    email: email,
    password: "298adfab4t324bg756b0",
  )
      .then((current_user) async {
    await current_user.user!.delete();
    return false;
  }).onError((error, stackTrace) {
    if (error.toString().contains("email") &&
        error.toString().contains("already") &&
        error.toString().contains("use")) {
      return true;
    } else {
      return true;
    }
  });
  return false;
}

Future<bool> check_if_user_exist_by_id({
  required String user_id,
}) async {
  await FirebaseFirestore.instance.collection("users").doc(user_id).get().then((doc) {
    return doc.exists;
  }).onError((error, stackTrace) {
    return false;
  });
  return false;
}
