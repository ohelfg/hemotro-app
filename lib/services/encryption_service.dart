import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionService {
  late final encrypt.Key _key;
  late final encrypt.IV _iv;

  EncryptionService() {
    // Initialize with a fixed key for demo purposes
    // Key must be 32 bytes (256 bits) for AES-256
    _key = encrypt.Key.fromUtf8('HemoTroAppSecretKeyForAES256Encrypt');
    // IV must be 16 bytes (128 bits)
    _iv = encrypt.IV.fromUtf8('HemoTroIV1234567');
  }

  /// Encrypt video URL
  String encryptVideoUrl(String videoUrl) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final encrypted = encrypter.encrypt(videoUrl, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Error encrypting video URL: $e');
      return videoUrl;
    }
  }

  /// Decrypt video URL
  String decryptVideoUrl(String encryptedUrl) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final decrypted = encrypter.decrypt64(encryptedUrl, iv: _iv);
      return decrypted;
    } catch (e) {
      print('Error decrypting video URL: $e');
      return encryptedUrl;
    }
  }

  /// Generate device fingerprint
  String generateDeviceFingerprint() {
    // This is a simple implementation
    // In production, use device_info_plus to get real device info
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 12345).toString();
    return base64Encode(utf8.encode(random));
  }

  /// Verify device fingerprint
  bool verifyDeviceFingerprint(String fingerprint) {
    try {
      base64Decode(fingerprint);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Generate license token
  String generateLicenseToken(String userId, String deviceId) {
    final data = {
      'userId': userId,
      'deviceId': deviceId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiresAt': DateTime.now()
          .add(const Duration(days: 30))
          .millisecondsSinceEpoch,
    };
    final jsonString = jsonEncode(data);
    return base64Encode(utf8.encode(jsonString));
  }

  /// Verify license token
  bool verifyLicenseToken(String token) {
    try {
      final decoded = utf8.decode(base64Decode(token));
      final data = jsonDecode(decoded) as Map<String, dynamic>;
      
      final expiresAt = data['expiresAt'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      return now < expiresAt;
    } catch (e) {
      return false;
    }
  }

  /// Hash password
  String hashPassword(String password) {
    // Simple hash for demo - in production use bcrypt or similar
    return base64Encode(utf8.encode(password));
  }

  /// Verify password
  bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }
}
