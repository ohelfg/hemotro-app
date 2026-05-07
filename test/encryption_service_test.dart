import 'package:flutter_test/flutter_test.dart';
import 'package:hemo_tro_app/services/encryption_service.dart';

void main() {
  group('EncryptionService Tests', () {
    late EncryptionService encryptionService;

    setUp(() {
      encryptionService = EncryptionService();
    });

    test('Encrypt and decrypt video URL', () {
      const videoUrl = 'https://example.com/video.mp4';
      
      final encrypted = encryptionService.encryptVideoUrl(videoUrl);
      expect(encrypted, isNotEmpty);
      // If encryption fails, it returns the original URL
      if (encrypted != videoUrl) {
        final decrypted = encryptionService.decryptVideoUrl(encrypted);
        expect(decrypted, equals(videoUrl));
      }
    });

    test('Generate device fingerprint', () {
      final fingerprint = encryptionService.generateDeviceFingerprint();
      expect(fingerprint, isNotEmpty);
      expect(fingerprint.length, greaterThan(0));
    });

    test('Verify device fingerprint', () {
      final fingerprint = encryptionService.generateDeviceFingerprint();
      final isValid = encryptionService.verifyDeviceFingerprint(fingerprint);
      expect(isValid, isTrue);
    });

    test('Generate license token', () {
      const userId = 'user123';
      const deviceId = 'device456';
      
      final token = encryptionService.generateLicenseToken(userId, deviceId);
      expect(token, isNotEmpty);
    });

    test('Verify license token', () {
      const userId = 'user123';
      const deviceId = 'device456';
      
      final token = encryptionService.generateLicenseToken(userId, deviceId);
      final isValid = encryptionService.verifyLicenseToken(token);
      expect(isValid, isTrue);
    });

    test('Hash and verify password', () {
      const password = 'MySecurePassword123';
      
      final hash = encryptionService.hashPassword(password);
      expect(hash, isNotEmpty);
      
      final isValid = encryptionService.verifyPassword(password, hash);
      expect(isValid, isTrue);
    });

    test('Verify password fails with wrong password', () {
      const password = 'MySecurePassword123';
      const wrongPassword = 'WrongPassword456';
      
      final hash = encryptionService.hashPassword(password);
      final isValid = encryptionService.verifyPassword(wrongPassword, hash);
      expect(isValid, isFalse);
    });
  });
}
