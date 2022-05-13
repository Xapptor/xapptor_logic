import 'package:url_launcher/url_launcher.dart';

// Launch URL with fallback.

launch_url(String url, String fallback_url) async {
  try {
    if (!await launchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(fallback_url),
      );
    }
    ;
  } catch (e) {
    print(e);
    await launchUrl(
      Uri.parse(fallback_url),
    );
  }
}
