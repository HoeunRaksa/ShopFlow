import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  static String get baseUrl {
    // Flutter Web
    if (kIsWeb) {
      return "http://localhost:8080/api";
    }

    // Android emulator / real phone
    if (Platform.isAndroid) {
      const bool realPhone = false;

      if (realPhone) {
        return "http://192.168.1.5:8080/api";
      }

      return "http://10.0.2.2:8080/api";
    }

    // Windows desktop
    if (Platform.isWindows) {
      return "http://localhost:8080/api";
    }

    return "http://localhost:8080/api";
  }
}