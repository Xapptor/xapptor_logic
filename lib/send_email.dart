import 'package:cloud_firestore/cloud_firestore.dart';

send_email({
  required String to,
  required String subject,
  required String text,
  required String html,
}) async {
  FirebaseFirestore.instance.collection("emails").doc().set({
    "to": to,
    "message": {
      "subject": subject,
      "text": text,
      "html": html,
    }
  });
}