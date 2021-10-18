import 'package:cloud_firestore/cloud_firestore.dart';

// Coupon Model.

class Coupon {
  final String id;
  final DateTime date_created;
  final DateTime date_expiry;
  final bool used;
  final String user_id;
  final String product_id;

  const Coupon({
    required this.id,
    required this.date_created,
    required this.date_expiry,
    required this.used,
    required this.user_id,
    required this.product_id,
  });

  Coupon.from_snapshot(String id, Map<String, dynamic> snapshot)
      : id = id,
        date_created = (snapshot['date_created'] as Timestamp).toDate(),
        date_expiry = (snapshot['date_expiry'] as Timestamp).toDate(),
        used = snapshot['used'] ?? false,
        user_id = snapshot['user_id'] ?? "",
        product_id = snapshot['product_id'];

  Map<String, dynamic> to_json() {
    return {
      'date_created': date_created,
      'date_expiry': date_expiry,
      'used': used,
      'user_id': user_id,
      'product_id': product_id,
    };
  }
}
