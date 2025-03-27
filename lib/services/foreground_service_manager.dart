import 'package:flutter/services.dart';

class ForegroundServiceManager {
  static const platform = MethodChannel('com.example.ablecred/foreground_service');

  static Future<void> startService() async {
    try {
      await platform.invokeMethod('startService');
    } on PlatformException catch (e) {
      print('Failed to start service: ${e.message}');
      rethrow;
    }
  }

  static Future<void> stopService() async {
    try {
      await platform.invokeMethod('stopService');
    } on PlatformException catch (e) {
      print('Failed to stop service: ${e.message}');
      rethrow;
    }
  }
} 