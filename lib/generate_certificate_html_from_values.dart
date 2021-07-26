import 'package:cloud_firestore/cloud_firestore.dart';

class HtmlCertificateFromValues {
  Future<String> generate({
    required String course_name,
    required String user_name,
    required String date,
    required String id,
  }) async {
    DocumentSnapshot firestore_html_certificate = await FirebaseFirestore
        .instance
        .collection('templates')
        .doc("certificate")
        .get();

    String firestore_html_certificate_text =
        firestore_html_certificate.get("html");

    firestore_html_certificate_text
        .replaceAll('[course_name]', course_name)
        .replaceAll('[user_name]', user_name)
        .replaceAll('[date]', date)
        .replaceAll('[certificate_id]', id);

    return firestore_html_certificate_text;
  }
}
