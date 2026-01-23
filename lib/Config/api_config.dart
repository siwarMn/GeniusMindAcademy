// Simple class to store API configuration
class ApiConfig {
  // Change this to your backend server address
  // - For Android Emulator: use 10.0.2.2
  // - For Physical Device: use your computer's IP (e.g., 192.168.1.100)
  static const String serverIp = 'localhost';
  static const int serverPort = 8080;

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
