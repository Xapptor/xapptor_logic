import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:xapptor_logic/file_downloader/file_downloader.dart';
import 'package:xapptor_logic/models/coupon.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

// GET

// Get coupons usage info.

get_coupons_usage_info(
  Timestamp date_created,
) async {
  QuerySnapshot coupon_query_snapshot =
      await FirebaseFirestore.instance.collection("coupons").where("date_created", isEqualTo: date_created).get();

  List<DocumentSnapshot> coupon_query_snapshot_docs = coupon_query_snapshot.docs;

  List<Coupon> coupons = [];
  List<String> name_list = [];
  List<String> course_was_completed_list = [];

  coupon_query_snapshot_docs.removeWhere((element) => element.id == "template");

  for (var element in coupon_query_snapshot_docs) {
    Coupon coupon = Coupon.from_snapshot(
      element.id,
      element.data() as Map<String, dynamic>,
    );

    coupons.add(coupon);

    if (coupon.user_id != "") {
      DocumentSnapshot user_snap = await FirebaseFirestore.instance.collection("users").doc(coupon.user_id).get();

      Map user_data = user_snap.data() as Map<String, dynamic>;

      String fullname = user_data["firstname"] + " " + user_data["lastname"];

      debugPrint("user_data -------------");
      debugPrint(fullname);

      name_list.add(fullname);

      bool course_was_completed = false;

      if (user_data["units_completed"] != null) {
        course_was_completed = (user_data["units_completed"] as List).length >= 4;
      }

      course_was_completed_list.add(course_was_completed ? "Yes" : "No");
    } else {
      name_list.add("");
      course_was_completed_list.add("");
    }
  }

  Timer(const Duration(seconds: 3), () {
    debugPrint(coupons.length.toString());
    debugPrint(name_list.length.toString());
    debugPrint(course_was_completed_list.length.toString());

    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName("A1").setText("Coupon ID");
    sheet.getRangeByName("B1").setText("Used by");
    sheet.getRangeByName("C1").setText("The course was completed");

    for (var i = 0; i < coupons.length; i++) {
      sheet.getRangeByName("A${i + 2}").setText(coupons[i].id);
      sheet.getRangeByName("B${i + 2}").setText(name_list[i]);
      sheet.getRangeByName("C${i + 2}").setText(course_was_completed_list[i]);
    }

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);

    String file_name = "coupons_usage_info_${date_created.toDate()}.xlsx";
    file_name = file_name.replaceAll(":", "_").replaceAll("-", "_").replaceAll(" ", "_").replaceFirst(".", "_");

    FileDownloader.save(
      src: workbook.saveAsStream(),
      file_name: file_name,
    );
    workbook.dispose();
  });
}
