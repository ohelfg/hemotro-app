import 'package:flutter/services.dart';

class ScreenRecordingProtection {
  static const platform = MethodChannel('com.hemo_tro.app/screen_recording');

  /// Enable screen recording protection
  static Future<void> enableProtection() async {
    try {
      await platform.invokeMethod('enableScreenRecordingProtection');
      print('Screen recording protection enabled');
    } catch (e) {
      print('Error enabling screen recording protection: $e');
    }
  }

  /// Disable screen recording protection
  static Future<void> disableProtection() async {
    try {
      await platform.invokeMethod('disableScreenRecordingProtection');
      print('Screen recording protection disabled');
    } catch (e) {
      print('Error disabling screen recording protection: $e');
    }
  }

  /// Check if screen is being recorded
  static Future<bool> isScreenBeingRecorded() async {
    try {
      final result = await platform.invokeMethod<bool>('isScreenRecording');
      return result ?? false;
    } catch (e) {
      print('Error checking screen recording: $e');
      return false;
    }
  }

  /// Enable secure flag for video player
  static Future<void> enableSecureFlag() async {
    try {
      await platform.invokeMethod('enableSecureFlag');
      print('Secure flag enabled');
    } catch (e) {
      print('Error enabling secure flag: $e');
    }
  }

  /// Disable secure flag
  static Future<void> disableSecureFlag() async {
    try {
      await platform.invokeMethod('disableSecureFlag');
      print('Secure flag disabled');
    } catch (e) {
      print('Error disabling secure flag: $e');
    }
  }
}
