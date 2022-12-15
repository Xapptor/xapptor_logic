import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_platform/universal_platform.dart';

// Check if payments are enabled in the current platform.
// Search param in metadata collection of Firebase Firestore.

Future<bool> check_if_payments_are_enabled() async {
  var payment_snap = await FirebaseFirestore.instance
      .collection("metadata")
      .doc("payments")
      .get();

  if (payment_snap.exists) {
    Map payment_data = payment_snap.data() as Map;
    bool payment_enabled = false;

    if (UniversalPlatform.isAndroid) {
      payment_enabled = payment_data["enabled"]["android"] ?? false;
    } else if (UniversalPlatform.isIOS) {
      payment_enabled = payment_data["enabled"]["ios"] ?? false;
    } else if (UniversalPlatform.isWeb) {
      payment_enabled = payment_data["enabled"]["web"] ?? false;
    }
    return payment_enabled;
  } else {
    return false;
  }
}
