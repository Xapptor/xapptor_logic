import 'package:flutter/material.dart';
import 'package:xapptor_routing/initial_values_routing.dart';
import 'package:xapptor_ui/widgets/show_custom_dialog.dart';

check_payment_result(BuildContext context) {
  if (current_app_path.contains("payment_success")) {
    show_payment_result_alert_dialog(
      current_app_path.toUpperCase().contains("TRUE"),
      context,
    );
    current_app_path = "";
  }
}
