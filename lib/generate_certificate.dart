import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'email_sender.dart';
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

  String firestore_html_certificate_text =
      firestore_html_certificate.get("html");

  firestore_html_certificate_text = firestore_html_certificate_text
      .replaceAll('[course_name]', course_name)
      .replaceAll('[user_name]', user_name)
      .replaceAll('[date]', date)
      .replaceAll('[certificate_id]', id);

  return firestore_html_certificate_text;
}

check_if_exist_certificate(
  String user_id,
  String course_id,
  String course_name,
  BuildContext context,
) async {
  bool user_already_has_courses_certificate = false;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user_id)
      .get()
      .then((DocumentSnapshot doc_snap_user) {
    Map<String, dynamic> user_data =
        doc_snap_user.data() as Map<String, dynamic>;

    if (user_data["certificates"] == null) {
      generate_certificate(
        user_id,
        user_data,
        course_name,
        course_id,
        false,
        context,
      );
    } else {
      List certificates = user_data["certificates"];
      print(certificates);

      for (int i = 0; i < certificates.length; i++) {
        FirebaseFirestore.instance
            .collection('certificates')
            .doc(certificates[i])
            .get()
            .then((DocumentSnapshot doc_snap_certificate) {
          print(doc_snap_certificate.data);

          print("course_id: " + doc_snap_certificate.get("course_id"));
          print("widget.courseID: " + course_id);

          if (doc_snap_certificate.get("course_id") == course_id)
            user_already_has_courses_certificate = true;

          if (i == certificates.length - 1) {
            print("final checkIfExistCertificate: " +
                user_already_has_courses_certificate.toString());

            generate_certificate(
              user_id,
              user_data,
              course_id,
              course_name,
              user_already_has_courses_certificate,
              context,
            );
          }
        });
      }
    }
  });
}

generate_certificate(
  String user_id,
  Map user_info,
  String course_id,
  String course_name,
  bool exist_certificate,
  BuildContext context,
) async {
  if (!exist_certificate) {
    FirebaseFirestore.instance
        .collection("certificates")
        .add({
          "course_id": course_id,
          "date": FieldValue.serverTimestamp(),
          "user_id": user_id,
        })
        .then((new_doc) => {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(user_id)
                  .update({
                "certificates": FieldValue.arrayUnion([new_doc.id]),
              }).catchError((err) => print(err)),
              FirebaseFirestore.instance
                  .collection('templates')
                  .doc("certificate")
                  .get()
                  .then((DocumentSnapshot doc_snap) async {
                DocumentSnapshot new_doc_snap = await new_doc.get();

                String html_certificate_result =
                    await generate_html_certificate(
                  course_name: course_name,
                  user_name:
                      user_info["firstname"] + " " + user_info["lastname"],
                  date: timestamp_to_date(new_doc_snap.get("date")),
                  id: new_doc.id,
                );

                User user = FirebaseAuth.instance.currentUser!;

                EmailSender()
                    .send(
                      to: user.email!,
                      subject:
                          "${user_info["firstname"]} ${user_info["lastname"]}, here is your certificate for Lean Six Sigma",
                      text: "New Message",
                      html: html_certificate_result,
                    )
                    .then((value) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Certificate sent! ✉️"),
                              duration: Duration(seconds: 3),
                            ),
                          ),
                        })
                    .catchError((err) => print(err));
              }),
            })
        .catchError((err) {
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
