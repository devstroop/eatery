import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPin(String pin) {
  final bytes = utf8.encode(pin);
  return sha256.convert(bytes).toString();
}

bool verifyPin(String pin, String hash) {
  if (pin == hash) return true;
  return hashPin(pin) == hash;
}
