import 'dart:typed_data';
import 'package:codajoy/models/course_model.dart';
import 'package:codajoy/Config/api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Service to get courses from backend
class CoursesService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Get the JWT token
  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Get all courses from backend
  Future<List<Course>> getCourses() async {
    try {
      String? token = await _getToken();
      String url = '${ApiConfig.baseUrl}/File/GETAll';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) => Course.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting courses: $e');
      return [];
    }
  }

  // Get PDF file bytes for viewing
  Future<Uint8List?> getPdfFile(int fileId) async {
    try {
      String? token = await _getToken();
      String url = '${ApiConfig.baseUrl}/File/$fileId';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }
      return null;
    } catch (e) {
      print('Error getting PDF: $e');
      return null;
    }
  }

  // Upload a new PDF file
  Future<bool> uploadFile(Uint8List fileBytes, String fileName) async {
    try {
      String? token = await _getToken();

      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await _dio.post(
        '${ApiConfig.baseUrl}/File/Add',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error uploading file: $e');
      return false;
    }
  }

  // Delete a file
  Future<bool> deleteFile(int fileId) async {
    try {
      String? token = await _getToken();

      final response = await _dio.delete(
        '${ApiConfig.baseUrl}/File/$fileId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}
