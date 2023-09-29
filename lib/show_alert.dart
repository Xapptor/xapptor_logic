import 'dart:async';
import 'package:flutter/material.dart';

enum AlertType {
  success,
  neutral,
  error,
}

show_alert({
  required BuildContext context,
  required String message,
  required AlertType alert_type,
  required Duration delay,
}) {
  Timer(delay, () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: alert_type == AlertType.success
            ? Colors.green
            : alert_type == AlertType.error
                ? Colors.red
                : null,
        content: Text(
          message,
        ),
      ),
    );
  });
}

show_success_alert({
  required BuildContext context,
  required String message,
  Duration delay = Duration.zero,
}) {
  show_alert(
    context: context,
    message: message,
    alert_type: AlertType.success,
    delay: delay,
  );
}

show_neutral_alert({
  required BuildContext context,
  required String message,
  Duration delay = Duration.zero,
}) {
  show_alert(
    context: context,
    message: message,
    alert_type: AlertType.neutral,
    delay: delay,
  );
}

show_error_alert({
  required BuildContext context,
  required String message,
  Duration delay = Duration.zero,
}) {
  show_alert(
    context: context,
    message: message,
    alert_type: AlertType.error,
    delay: delay,
  );
}
