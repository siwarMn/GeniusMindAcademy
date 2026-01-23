import 'dart:convert';
import 'package:codajoy/models/auth_models.dart';
import 'package:codajoy/modals/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart'; // for XFile

class AuthService {
  final Dio _dio = Dio();
  // Using localhost for Web, 10.0.2.2 for Android Emulator
  // Note: For Web to work with localhost, the backend must support CORS.
  final String _baseUrl = kIsWeb 
      ? 'http://localhost:8080/api/v1/auth' 
      : 'http://localhost:8080/api/v1/auth';
  final _storage = const FlutterSecureStorage();

  Future<AuthenticationResponse> register(
      XFile? file, RegisterRequest request) async {
    try {
      String requestJson = jsonEncode(request.toJson());
      
      FormData formData = FormData.fromMap({
        'request': requestJson,
      });

      if (file != null) {
        String fileName = file.name;
        MultipartFile multipartFile;

        if (kIsWeb) {
          // On Web, we must read bytes
          final bytes = await file.readAsBytes();
          multipartFile = MultipartFile.fromBytes(
            bytes,
            filename: fileName,
          );
        } else {
          // On Mobile, path is safe
          multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          );
        }

        formData.files.add(MapEntry('file', multipartFile));
      }

      final response = await _dio.post(
        '$_baseUrl/register',
        data: formData,
      );

      if (response.statusCode == 200) {
        return AuthenticationResponse(); 
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Registration error: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error during registration: $e');
    }
  }

  Future<AuthenticationResponse> authenticate(AuthenticationRequest request) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/authenticate',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthenticationResponse.fromJson(response.data);
        if (authResponse.token != null) {
          await _storage.write(key: 'jwt_token', value: authResponse.token);
        }
        return authResponse;
      } else {
         throw Exception('Authentication failed');
      }
    } on DioException catch (e) {
      throw Exception('Login error: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> body, {XFile? image}) async {
    try {
      // Backend expects 'multipart/form-data' with 'request' parameter containing JSON string
      String userJson = jsonEncode(body);
      FormData formData = FormData.fromMap({
        'request': userJson,
      });

      // Add image file if provided
      if (image != null) {
        String fileName = image.name;
        MultipartFile multipartFile;

        if (kIsWeb) {
           final bytes = await image.readAsBytes();
           multipartFile = MultipartFile.fromBytes(bytes, filename: fileName);
        } else {
           multipartFile = await MultipartFile.fromFile(image.path, filename: fileName);
        }
        formData.files.add(MapEntry('file', multipartFile));
      }

      // Get Token
      String? token = await getToken();
      if (token == null) throw Exception("No auth token found");

      final response = await _dio.put(
        '$_baseUrl/profile',
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Failed to update profile: Status ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Update error: ${e.response?.data ?? e.message}');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}
