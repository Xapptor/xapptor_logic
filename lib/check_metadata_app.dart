import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_platform/universal_platform.dart';

check_metadata_app() async {
  bool app_enabled = false;
  DocumentSnapshot metadata_app =
      await FirebaseFirestore.instance.collection('metadata').doc('app').get();

  if (UniversalPlatform.isWeb) {
    app_enabled = metadata_app["enabled"]["web"];
  } else if (UniversalPlatform.isAndroid) {
    app_enabled = metadata_app["enabled"]["android"];
  } else if (UniversalPlatform.isIOS) {
    app_enabled = metadata_app["enabled"]["ios"];
  }
  print("app_enabled: $app_enabled");
  if (!app_enabled) exit(0);
}
