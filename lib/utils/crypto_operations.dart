import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart';

String calculateSHA256DigestFromString(String string) {
  final Digest digest = sha256.convert(utf8.encode(string));
  return digest.toString();
}

String calculateSHA256FromBytes(List<int> bytes) {
  final Digest digest = sha256.convert(bytes); // Hashing Process
  return digest.toString();
}
