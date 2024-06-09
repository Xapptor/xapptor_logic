import 'dart:convert';
import 'package:crypto/crypto.dart';

String sha256_of_string(String input) {
  final bytes = utf8.encode(input);
  return sha256.convert(bytes).toString();
}
