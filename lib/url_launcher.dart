import 'package:url_launcher/url_launcher.dart';

Future<void> launch_url(String url, String fallback_url) async {
  try {
    bool launched = await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );

    if (!launched)
      await launch(
        fallback_url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
  } catch (e) {
    await launch(
      fallback_url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  }
}
