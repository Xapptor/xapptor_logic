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
  required Duration duration,
}) {
  Timer(duration, () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
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
  Duration duration = Duration.zero,
}) {
  show_alert(
    context: context,
    message: message,
    alert_type: AlertType.success,
    duration: duration,
  );
}

show_neutral_alert({
  required BuildContext context,
  required String message,
  Duration duration = Duration.zero,
}) {
  show_alert(
    context: context,
    message: message,
    alert_type: AlertType.neutral,
    duration: duration,
  );
}

show_error_alert({
  required BuildContext context,
  required String message,
  Duration duration = Duration.zero,
}) {
  show_alert(
    context: context,
    message: message,
    alert_type: AlertType.error,
    duration: duration,
  );
}
