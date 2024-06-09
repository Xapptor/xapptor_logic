import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_logic/models/coupon.dart';

// CHECK

// Check if coupon is valid.

Future<String> check_if_coupon_is_valid(
  String coupon_id,
  BuildContext context,
  String valid_message,
  String invalid_message,
) async {
  String? user_id = FirebaseAuth.instance.currentUser?.uid;
  bool coupon_is_valid = false;

  if (user_id == null) return "login";

  DocumentSnapshot coupon_snapshot = await FirebaseFirestore.instance.collection("coupons").doc(coupon_id).get();

  if (coupon_snapshot.exists) {
    Coupon coupon = Coupon.from_snapshot(
      coupon_snapshot.id,
      coupon_snapshot.data() as Map<String, dynamic>,
    );

    if (coupon.user_id.isEmpty || coupon.user_id == user_id) {
      int date_difference = coupon.date_expiry.compareTo(DateTime.now());
      if (!coupon.used) {
        if (date_difference > 0) {
          coupon_is_valid = true;

          await coupon_snapshot.reference.update({
            "used": true,
            "user_id": user_id,
            "date_used": FieldValue.serverTimestamp(),
          });

          await FirebaseFirestore.instance.collection("users").doc(user_id).update({
            "products_acquired": FieldValue.arrayUnion([coupon.product_id]),
          });
        }
      }
    }
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          coupon_is_valid ? valid_message : invalid_message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Icon(
          coupon_is_valid ? Icons.check_circle_rounded : Icons.info,
          color: Colors.white,
        ),
        backgroundColor: coupon_is_valid ? Colors.green : Colors.red,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
          ),
        ],
      ),
    );
  }

  await Future.delayed(const Duration(milliseconds: 2300));
  if (context.mounted) ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  return coupon_is_valid ? "home/courses" : "";
}
