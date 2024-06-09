import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timestamp_to_date_string(Timestamp time_stamp) {
  DateTime date_now = time_stamp.toDate();
  DateFormat date_formatter = DateFormat.yMMMMd('en_US');
  String date_now_formatted = date_formatter.format(date_now);
  return date_now_formatted;
}
