import 'package:url_launcher/url_launcher.dart';

// Launch URL with fallback.

Future<void> launch_url(String url, String fallback_url) async {
  try {
    bool launched = await launchUrl(Uri.parse(url));

    if (!launched) await launchUrl(Uri.parse(fallback_url));
  } catch (e) {
    await launchUrl(Uri.parse(fallback_url));
  }
}
