import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_router/V2/app_screens_v2.dart';
import 'authentication_needed_alert.dart';
import 'package:xapptor_db/xapptor_db.dart';

enum ReachLimit {
  by_day,
  by_duration,
}

check_limit_per_date({
  required String new_value,
  required BuildContext context,
  required String reached_limit_alert_title,
  required Function check_limit_per_date_callback,
  required int cache_lifetime_in_seconds,
  required int limit,
  required String limit_field_name,
  required String array_field_name,
  required ReachLimit reach_limit,
  required bool save_same_value_multiple_times,
}) async {
  User? current_user = FirebaseAuth.instance.currentUser;
  if (current_user != null) {
    var user_snap = await XapptorDB.instance.collection("users").doc(current_user.uid).get();
    Map user_data = user_snap.data() as Map;

    Map<String, dynamic>? limit_field = user_data[limit_field_name];

    bool clean_values = false;
    bool call_add_new_value = false;

    if (limit_field != null) {
      DateTime now = DateTime.now();
      DateTime translation_limit_date = (limit_field["date"] as Timestamp).toDate();

      bool pass_the_limit = false;

      if (reach_limit == ReachLimit.by_day) {
        if (now.day != translation_limit_date.day) {
          pass_the_limit = true;
        }
      } else {
        if (now.difference(translation_limit_date).inSeconds > cache_lifetime_in_seconds) {
          pass_the_limit = true;
        }
      }

      if (pass_the_limit) {
        clean_values = true;
        call_add_new_value = true;
      } else {
        if (limit_field[array_field_name] != null) {
          List limit_remote = limit_field[array_field_name];

          if (limit_remote.contains(new_value) && !save_same_value_multiple_times) {
            check_limit_per_date_callback();
          } else {
            if (limit_remote.length < limit) {
              call_add_new_value = true;
            } else {
              if (context.mounted) {
                reached_limit_alert(
                  context: context,
                  title: reached_limit_alert_title,
                );
              }
            }
          }
        } else {
          call_add_new_value = true;
        }
      }
    } else {
      call_add_new_value = true;
    }
    if (call_add_new_value) {
      add_new_value(
        new_value: new_value,
        user_snap: user_snap,
        clean_values: clean_values,
        limit_field: limit_field ?? {},
        check_limit_per_date_callback: check_limit_per_date_callback,
        limit_field_name: limit_field_name,
        array_field_name: array_field_name,
      );
    }
  } else {
    authentication_needed_alert(
      context: context,
      accept_button_callback: () {
        open_screen_v2("login");
      },
    );
  }
}

add_new_value({
  required String new_value,
  required DocumentSnapshot user_snap,
  required bool clean_values,
  required Map<String, dynamic> limit_field,
  required Function check_limit_per_date_callback,
  required String limit_field_name,
  required String array_field_name,
}) async {
  limit_field["date"] = Timestamp.now();
  if (clean_values || limit_field[array_field_name] == null) {
    limit_field[array_field_name] = [new_value];
  } else {
    (limit_field[array_field_name] as List).add(new_value);
  }
  await user_snap.reference.update({limit_field_name: limit_field});
  check_limit_per_date_callback();
}

reached_limit_alert({
  required BuildContext context,
  required String title,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
