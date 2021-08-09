import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'email_sender.dart';
import 'get_user_info.dart';
import 'timestamp_to_date.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> generate_html_certificate({
  required String course_name,
  required String user_name,
  required String date,
  required String id,
}) async {
  DocumentSnapshot firestore_html_certificate = await FirebaseFirestore.instance
      .collection('templates')
      .doc("certificate")
      .get();

  String firestore_html_certificate_text = firestore_html_certificate
      .get("html")
      .replaceAll('[course_name]', course_name)
      .replaceAll('[user_name]', user_name)
      .replaceAll('[date]', date)
      .replaceAll('[certificate_id]', id);

  return firestore_html_certificate_text;
}

check_if_exist_certificate(
  String course_id,
  String course_name,
  BuildContext context,
) async {
  User user = FirebaseAuth.instance.currentUser!;
  Map user_info = await get_user_info(user.uid);
  List<String>? certificates = user_info["certificates"];
  print("certificates: $certificates");

  bool has_certificates = false;
  bool has_certificate = false;

  if (certificates != null) {
    if (certificates.isNotEmpty) {
      has_certificates = true;
    }
  }

  if (has_certificates) {
    for (var certificate in certificates!) {
      FirebaseFirestore.instance
          .collection('certificates')
          .doc(certificate)
          .get()
          .then((DocumentSnapshot snapshot_certificate) {
        String snapshot_course_id = snapshot_certificate.get("course_id");
        print(snapshot_certificate.data);

        print("snapshot_certificate_course_id: " + snapshot_course_id);

        if (snapshot_course_id == course_id) {
          has_certificate = true;
        }
      });
    }
  }

  generate_certificate(
    user,
    user_info,
    course_id,
    course_name,
    has_certificate,
    context,
  );
}

generate_certificate(
  User user,
  Map user_info,
  String course_id,
  String course_name,
  bool has_certificate,
  BuildContext context,
) async {
  if (!has_certificate) {
    FirebaseFirestore.instance.collection("certificates").add({
      "course_id": course_id,
      "date": FieldValue.serverTimestamp(),
      "user_id": user.uid,
    }).then((new_certificate) {
      FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "certificates": FieldValue.arrayUnion([new_certificate.id]),
      }).catchError((err) => print(err));

      FirebaseFirestore.instance
          .collection('templates')
          .doc("certificate")
          .get()
          .then((DocumentSnapshot certificate_template) async {
        String html_certificate = await generate_html_certificate(
          course_name: course_name,
          user_name: user_info["firstname"] + " " + user_info["lastname"],
          date: timestamp_to_date(certificate_template.get("date")),
          id: new_certificate.id,
        );

        EmailSender()
            .send(
              to: user.email!,
              subject:
                  "Hello ${user_info["firstname"]} ${user_info["lastname"]}, here is your $course_name certificate!",
              text: "New Message",
              html: html_certificate,
            )
            .then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Certificate email sent! ✉️"),
                      duration: Duration(seconds: 3),
                    ),
                  ),
                })
            .catchError((err) => print(err));
      });
    }).catchError((err) {
      print(err);
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You already have this certificate 👍"),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
