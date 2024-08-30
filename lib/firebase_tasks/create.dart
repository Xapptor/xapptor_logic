import 'package:intl/intl.dart';
import 'package:xapptor_logic/firebase_tasks/duplicate.dart';

// CREATE

// Create coupons.

Future<void> create_coupons({
  required int times,
  String? base_id,
  Map<String, dynamic>? add_values,
  Map<String, dynamic>? update_values,
}) async {
  await duplicate_document(
    document_id: "template",
    collection_id: "coupons",
    times: times,
    base_id: "${base_id}_d_${DateFormat('dd_MM_yy').format(DateTime.now())}",
    apply_random_number: true,
    add_values: add_values,
    update_values: update_values,
  );
}
