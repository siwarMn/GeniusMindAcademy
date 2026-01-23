import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart' as getx;
import 'package:codajoy/Config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Service to download PDF files
class DownloadService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Download a PDF file
  Future<void> downloadPdf(int fileId, String fileName) async {
    try {
      // Show starting message
      _showMessage("Telechargement", "Telechargement en cours...");

      // Get token
      String? token = await _storage.read(key: 'jwt_token');

      // Get download folder
      Directory? dir = await getApplicationDocumentsDirectory();
      String savePath = '${dir.path}/$fileName.pdf';

      // Download the file
      String url = '${ApiConfig.baseUrl}/File/download/$fileId';

      await _dio.download(
        url,
        savePath,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      _showMessage("Succes", "Fichier telecharge!");
    } catch (e) {
      _showMessage("Erreur", "Echec du telechargement");
    }
  }

  void _showMessage(String title, String message) {
    getx.Get.snackbar(
      title,
      message,
      snackPosition: getx.SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }
}
