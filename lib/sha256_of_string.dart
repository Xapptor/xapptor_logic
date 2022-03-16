import 'dart:convert';
import 'package:crypto/crypto.dart';

String sha256_of_string(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
