import 'package:encrypt/encrypt.dart';

class Encryption {
  static String aesKey = 'abcdefghijklmnopqrstuvwxyz012345';

  static String? encrypt(String raw) {
    try {
      final key = Key.fromUtf8(Encryption.aesKey);
      final iv = IV.fromLength(16);
      final encryptor = Encrypter(AES(key));
      final encrypted = encryptor.encrypt(raw, iv: iv);
      return encrypted.base16;
    } catch (exception) {
      return null;
    }
  }

  static String? decrypt(String encrypted) {
    try {
      final key = Key.fromUtf8(Encryption.aesKey);
      final iv = IV.fromLength(16);
      final encryptor = Encrypter(AES(key));
      final decrypted = encryptor.decrypt(Encrypted.fromBase16(encrypted), iv: iv);
      return decrypted;
    } catch (exception) {
      return null;
    }
  }
}
