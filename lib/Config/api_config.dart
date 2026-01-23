import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

// Simple class to store API configuration
class ApiConfig {
  // ================================================
  // CONFIGURATION - Change these for your setup
  // ================================================

  // Your computer's local IP address (for physical devices)
  // Find it with: ipconfig (Windows) or ifconfig (Mac/Linux)
  static const String _localIp = '192.168.1.100'; // <-- CHANGE THIS to your IP

  // Server port
  static const int serverPort = 8080;

  // ================================================
  // AUTO-DETECTION - Don't change below
  // ================================================

  // Automatically select the right IP based on platform
  static String get serverIp {
    if (kIsWeb) {
      // Web: use localhost (browser runs on same machine)
      return 'localhost';
    } else {
      // Mobile: use local IP for physical devices
      // For Android emulator, change _localIp to '10.0.2.2'
      return _localIp;
    }
  }

  // Base URL for the backend API
  static String get baseUrl => 'http://$serverIp:$serverPort/api/v1/auth';

  // File endpoints
  static String get fileUploadUrl => '$baseUrl/File/Add';
  static String get fileListUrl => '$baseUrl/File/GETAll';

  // Get URL to view a PDF file (opens inline in viewer)
  static String getFileViewUrl(int fileId) {
    return '$baseUrl/File/$fileId';
  }

  // Get URL to download a PDF file (forces download)
  static String getFileDownloadUrl(int fileId) {
    return '$baseUrl/File/download/$fileId';
  }
}
