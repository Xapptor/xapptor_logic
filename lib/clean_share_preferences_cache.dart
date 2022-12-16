import 'package:shared_preferences/shared_preferences.dart';

clean_share_preferences_cache({
  required String key_to_check,
  required String similar_keys_to_delete,
  required List<String> specific_keys_to_delete,
  required int cache_lifetime_in_seconds,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // prefs.setString(
  //   key_to_check,
  //   DateTime.now().subtract(Duration(days: 31)).toString(),
  // );

  if (prefs.getString(key_to_check) == null) {
    prefs.setString(
      key_to_check,
      DateTime.now().toString(),
    );
  } else {
    DateTime last_date_translations_updated =
        DateTime.parse(prefs.getString(key_to_check)!);

    int date_difference_in_seconds =
        DateTime.now().difference(last_date_translations_updated).inSeconds;

    int date_difference_in_days =
        (date_difference_in_seconds / Duration.secondsPerDay).floor();

    //print("date_difference_in_seconds: $date_difference_in_seconds");
    //print("date_difference_in_days: $date_difference_in_days");
    //print("cache_life_period_in_seconds: $cache_life_period_in_seconds");

    if (date_difference_in_seconds > cache_lifetime_in_seconds) {
      final prefs_keys = prefs.getKeys();
      for (String prefs_key in prefs_keys) {
        if (prefs_key.contains(similar_keys_to_delete)) {
          prefs.remove(prefs_key);
        }
      }

      prefs.remove(key_to_check);

      specific_keys_to_delete.forEach((key) {
        prefs.remove(key);
      });
    }
  }
}
