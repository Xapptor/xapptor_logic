import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_platform/universal_platform.dart';

Future<bool> check_if_payments_are_enabled() async {
  var payments_snap = await FirebaseFirestore.instance.collection("metadata").doc("payments").get();

  if (payments_snap.exists) {
    Map payments_data = payments_snap.data() as Map;

    bool payment_enabled = false;
    String platform_name = UniversalPlatform.operatingSystem.toString();
    payment_enabled = payments_data["enabled"][platform_name] ?? false;

    return payment_enabled;
  } else {
    return false;
  }
}
