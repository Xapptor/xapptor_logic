import 'package:flutter/material.dart';

authentication_needed_alert({
  required BuildContext context,
  required Function accept_button_callback,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("First you need to authenticate yourself"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Accept"),
            onPressed: () async {
              Navigator.of(context).pop();
              accept_button_callback();
            },
          ),
        ],
      );
    },
  );
}
