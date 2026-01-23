import 'package:codajoy/models/reclamation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReclamationService {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  final String _baseUrl = kIsWeb
      ? 'http://localhost:8080/api/v1/auth'
      : 'http://localhost:8080/api/v1/auth';

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<Map<String, String>> getHeaders() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('No token found. Please login first.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<ReclamationResponse>> getReclamations() async {
    try {
      Map<String, String> headers = await getHeaders();

      final response = await _dio.get(
        '$_baseUrl/getReclam',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<ReclamationResponse> reclamations = [];
        for (var item in data) {
          reclamations.add(ReclamationResponse.fromJson(item));
        }
        return reclamations;
      } else {
        throw Exception('Failed to load reclamations');
      }
    } catch (e) {
      throw Exception('Error loading reclamations: $e');
    }
  }

  Future<ReclamationResponse> createReclamation(
      String titre, String description, String categorie, String creerpar, String priority) async {
    try {
      Map<String, String> headers = await getHeaders();

      ReclamationRequest request = ReclamationRequest(
        titre: titre,
        categorie: categorie,
        description: description,
        creerpar: creerpar,
        priority: priority,
      );

      final response = await _dio.post(
        '$_baseUrl/addReclamation',
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return ReclamationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to create reclamation');
      }
    } catch (e) {
      throw Exception('Error creating reclamation: $e');
    }
  }

  Future<ReclamationResponse> assignReclamation(int id, String assignedTo) async {
    try {
      Map<String, String> headers = await getHeaders();
      AssignmentRequest request = AssignmentRequest(assignedTo: assignedTo);

      final response = await _dio.put(
        '$_baseUrl/assignReclam/$id',
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return ReclamationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to assign reclamation');
      }
    } catch (e) {
      throw Exception('Error assigning reclamation: $e');
    }
  }

  Future<ReclamationResponse> rateReclamation(int id, int rating) async {
    try {
      Map<String, String> headers = await getHeaders();
      RatingRequest request = RatingRequest(rating: rating);

      final response = await _dio.put(
        '$_baseUrl/rateReclam/$id',
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return ReclamationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to rate reclamation');
      }
    } catch (e) {
      throw Exception('Error rating reclamation: $e');
    }
  }

  Future<ReclamationResponse> updateStatus(int id, String status) async {
    try {
      Map<String, String> headers = await getHeaders();
      StatusUpdateRequest request = StatusUpdateRequest(status: status);

      final response = await _dio.put(
        '$_baseUrl/updateStatus/$id',
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return ReclamationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      throw Exception('Error updating status: $e');
    }
  }

  Future<void> deleteReclamation(int id) async {
    try {
      Map<String, String> headers = await getHeaders();

      final response = await _dio.delete(
        '$_baseUrl/deleteReclam/$id',
        options: Options(headers: headers),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete reclamation');
      }
    } catch (e) {
      throw Exception('Error deleting reclamation: $e');
    }
  }

  Future<CommentResponse> addComment(int id, String author, String text) async {
    try {
      Map<String, String> headers = await getHeaders();
      CommentRequest request = CommentRequest(author: author, text: text);

      final response = await _dio.post(
        '$_baseUrl/addComment/$id',
        data: request.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return CommentResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }
}
