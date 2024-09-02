import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<Map<String, dynamic>> get_user_info(String user_id) async {
  DocumentSnapshot user = await XapptorDB.instance.collection("users").doc(user_id).get();
  return user.data() as Map<String, dynamic>;
}
