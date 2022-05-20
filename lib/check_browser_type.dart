import 'package:device_info_plus/device_info_plus.dart';

enum BrowserType {
  desktop,
  mobile,
  none,
}

Future<BrowserType> check_browser_type() async {
  final device_info_plugin = DeviceInfoPlugin();
  final device_info = await device_info_plugin.deviceInfo;
  final map = device_info.toMap();

  BrowserType current_browser_type = BrowserType.none;

  if (map["browserName"] != null) {
    bool is_mobile = false;

    map.forEach((key, value) {
      if (value.toString().toLowerCase().contains("mobile")) {
        is_mobile = true;
      }
    });

    current_browser_type = is_mobile ? BrowserType.mobile : BrowserType.desktop;
  }
  return current_browser_type;
}
