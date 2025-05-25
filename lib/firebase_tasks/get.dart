import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:xapptor_logic/file_downloader/file_downloader.dart';
import 'package:xapptor_logic/models/certificate.dart';
import 'package:xapptor_logic/models/coupon.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:xapptor_db/xapptor_db.dart';

// GET

DateFormat long_formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
DateFormat short_formatter = DateFormat('yyyy-MM-dd');

// Get coupons usage info.

get_coupons_usage_info({
  required Timestamp start_date,
  Timestamp? end_date,
  bool get_only_used_coupons = false,
}) async {
  debugPrint('get_coupons_usage_info');

  Query coupons_query = XapptorDB.instance.collection("coupons");

  if (end_date == null) {
    coupons_query = coupons_query.where(
      "date_created",
      isEqualTo: start_date,
    );
  } else {
    coupons_query = coupons_query
        .where(
          "date_created",
          isGreaterThanOrEqualTo: start_date,
        )
        .where(
          "date_created",
          isLessThanOrEqualTo: end_date,
        );
  }

  if (get_only_used_coupons) {
    coupons_query = coupons_query.where(
      "user_id",
      isNotEqualTo: "",
    );
  }

  QuerySnapshot coupon_query_snapshot = await coupons_query.get();

  List<DocumentSnapshot> coupon_query_docs = coupon_query_snapshot.docs;

  List<Coupon> coupons = [];
  List<String> names = [];
  List<String> course_was_completed_list = [];
  List<String> certificate_dates = [];

  coupon_query_docs.removeWhere((element) => element.id == "template");

  for (var coupon_doc in coupon_query_docs) {
    Coupon coupon = Coupon.from_snapshot(
      coupon_doc.id,
      coupon_doc.data() as Map<String, dynamic>,
    );

    coupons.add(coupon);

    if (coupon.user_id != "") {
      DocumentSnapshot user_snap = await XapptorDB.instance.collection("users").doc(coupon.user_id).get();

      Map user_data = user_snap.data() as Map<String, dynamic>;

      String fullname = '${user_data["firstname"]} ${user_data["lastname"]}';

      debugPrint("user_data -------------");
      debugPrint(fullname);
      debugPrint('');

      names.add(fullname);

      bool course_was_completed = false;

      if (user_data["units_completed"] != null) {
        course_was_completed = (user_data["units_completed"] as List).length >= 4;
      }

      course_was_completed_list.add(course_was_completed ? "Yes" : "No");

      QuerySnapshot certificate_query =
          await XapptorDB.instance.collection("certificates").where("user_id", isEqualTo: coupon.user_id).get();

      if (certificate_query.docs.isNotEmpty) {
        DocumentSnapshot certificate_snap = certificate_query.docs.first;

        if (certificate_snap.data() != null) {
          Map certificate_data = certificate_snap.data() as Map<String, dynamic>;
          DateTime certificate_date = (certificate_data["date"] as Timestamp).toDate();

          String certificate_date_string = long_formatter.format(certificate_date);

          certificate_dates.add(certificate_date_string);
        } else {
          certificate_dates.add("");
        }
      } else {
        certificate_dates.add("");
      }
    } else {
      names.add("");
      course_was_completed_list.add("");
    }
  }

  final xlsio.Workbook workbook = xlsio.Workbook();
  final xlsio.Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("Coupon ID");
  sheet.getRangeByName("B1").setText("Used by");
  sheet.getRangeByName("C1").setText("The course was completed");
  sheet.getRangeByName("D1").setText("Certificate Date");
  sheet.getRangeByName("E1").setText("Total Pass Rate");

  final Style style = workbook.styles.add('Title');
  style.fontSize = 12;
  style.bold = true;

  sheet.getRangeByName("A1").cellStyle = style;
  sheet.getRangeByName("B1").cellStyle = style;
  sheet.getRangeByName("C1").cellStyle = style;
  sheet.getRangeByName("D1").cellStyle = style;
  sheet.getRangeByName("E1").cellStyle = style;

  for (var i = 0; i < coupons.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(coupons[i].id);
    sheet.getRangeByName("B${i + 2}").setText(names[i]);
    sheet.getRangeByName("C${i + 2}").setText(course_was_completed_list[i]);
    sheet.getRangeByName("D${i + 2}").setText(certificate_dates[i]);
  }
  int total_of_passes = course_was_completed_list.where((element) => element.toLowerCase() == "yes").length;
  double total_pass_rate = total_of_passes * 100 / coupons.length;

  String total_pass_rate_string = "${total_pass_rate.toStringAsFixed(2)}%";
  sheet.getRangeByName("E2").setText(total_pass_rate_string);

  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.autoFitColumn(5);

  String start_date_string = short_formatter.format(start_date.toDate());
  String end_date_string = end_date != null ? short_formatter.format(end_date.toDate()) : "";

  String date_range = end_date != null ? "${start_date_string}_$end_date_string" : start_date_string;

  String file_name = "coupons_usage_info_$date_range.xlsx";

  debugPrint("Coupons: ${coupons.length}");
  debugPrint("Pass Rate: $total_pass_rate_string");
  debugPrint("File Name: $file_name");

  FileDownloader.save(
    src: workbook.saveAsStream(),
    file_name: file_name,
  );
  workbook.dispose();
}

// Get certificates info.

get_certificates_info({
  required Timestamp start_date,
  Timestamp? end_date,
}) async {
  debugPrint('get_certificates_info');

  Query certificates_query = XapptorDB.instance.collection("certificates");

  if (end_date == null) {
    certificates_query = certificates_query.where(
      "date",
      isEqualTo: start_date,
    );
  } else {
    certificates_query = certificates_query
        .where(
          "date",
          isGreaterThanOrEqualTo: start_date,
        )
        .where(
          "date",
          isLessThanOrEqualTo: end_date,
        );
  }

  QuerySnapshot certificates_query_snapshot = await certificates_query.get();

  List<DocumentSnapshot> certificates_query_docs = certificates_query_snapshot.docs;

  List<Certificate> certificates = [];
  List<String> names = [];

  certificates_query_docs.removeWhere((element) => element.id == "template");

  for (var certificate_doc in certificates_query_docs) {
    Certificate certificate = Certificate.from_snapshot(
      certificate_doc.id,
      certificate_doc.data() as Map<String, dynamic>,
    );

    certificates.add(certificate);

    DocumentSnapshot user_snap = await XapptorDB.instance.collection("users").doc(certificate.user_id).get();

    Map user_data = user_snap.data() as Map<String, dynamic>;

    String fullname = '${user_data["firstname"]} ${user_data["lastname"]}';

    debugPrint("user_data -------------");
    debugPrint(fullname);
    debugPrint('');

    names.add(fullname);
  }

  final xlsio.Workbook workbook = xlsio.Workbook();
  final xlsio.Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName("A1").setText("Certificate ID");
  sheet.getRangeByName("B1").setText("Used by");
  sheet.getRangeByName("C1").setText("Certificate Date");

  final Style style = workbook.styles.add('Title');
  style.fontSize = 12;
  style.bold = true;

  sheet.getRangeByName("A1").cellStyle = style;
  sheet.getRangeByName("B1").cellStyle = style;
  sheet.getRangeByName("C1").cellStyle = style;

  for (var i = 0; i < certificates.length; i++) {
    sheet.getRangeByName("A${i + 2}").setText(certificates[i].id);
    sheet.getRangeByName("B${i + 2}").setText(names[i]);
    sheet.getRangeByName("C${i + 2}").setText(short_formatter.format(certificates[i].date));
  }

  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);

  String start_date_string = short_formatter.format(start_date.toDate());
  String end_date_string = end_date != null ? short_formatter.format(end_date.toDate()) : "";

  String date_range = end_date != null ? "${start_date_string}_$end_date_string" : start_date_string;

  String file_name = "certificates_info_$date_range.xlsx";

  debugPrint("Certificates: ${certificates.length}");
  debugPrint("File Name: $file_name");

  FileDownloader.save(
    src: workbook.saveAsStream(),
    file_name: file_name,
  );
  workbook.dispose();
}
