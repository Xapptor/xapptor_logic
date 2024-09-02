import 'package:xapptor_db/xapptor_db.dart';

Future send_email({
  required String to,
  required String subject,
  required String text,
  String? html,
}) async {
  var email_json = {
    "to": to,
    "message": {
      "subject": subject,
      "text": text,
    }
  };
  if (html != null) email_json["html"] = html;

  await XapptorDB.instance.collection("emails").doc().set(email_json);
}
