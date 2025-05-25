import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  final String id;
  final String course_id;
  final DateTime date;
  final String user_id;

  const Certificate({
    required this.id,
    required this.course_id,
    required this.date,
    required this.user_id,
  });

  Certificate.from_snapshot(this.id, Map<String, dynamic> snapshot)
      : course_id = snapshot['course_id'],
        date = (snapshot['date'] as Timestamp).toDate(),
        user_id = snapshot['user_id'] ?? "";

  Map<String, dynamic> to_json() {
    return {
      'course_id': course_id,
      'date': date,
      'user_id': user_id,
    };
  }
}
