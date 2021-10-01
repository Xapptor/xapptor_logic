import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_platform/universal_platform.dart';

Future<bool> check_if_payments_are_enabled() async {
  DocumentSnapshot payment_snapshot = await FirebaseFirestore.instance
      .collection("metadata")
      .doc("payments")
      .get();
  Map payment_data = payment_snapshot.data() as Map;
  bool payment_enabled = false;

  if (UniversalPlatform.isAndroid) {
    payment_enabled = payment_data["android"] ?? false;
  } else if (UniversalPlatform.isIOS) {
    payment_enabled = payment_data["ios"] ?? false;
  } else if (UniversalPlatform.isWeb) {
    payment_enabled = payment_data["web"] ?? false;
  }
  return payment_enabled;
}
