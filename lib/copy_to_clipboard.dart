import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xapptor_logic/show_alert.dart';

copy_to_clipboard({
  required String data,
  required String message,
  required BuildContext context,
}) async {
  await Clipboard.setData(
    ClipboardData(
      text: data,
    ),
  );
  show_success_alert(context: context, message: message);
}
