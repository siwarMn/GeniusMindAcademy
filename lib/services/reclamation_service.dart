import 'package:codajoy/models/reclamation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ReclamationService {
  final Dio _dio = Dio();

  final String _baseUrl = kIsWeb
      ? 'http://localhost:8080/api/v1/auth'
      : 'http://10.0.2.2:8080/api/v1/auth';

  Future<List<ReclamationResponse>> getReclamations() async {
    try {
      final response = await _dio.get('$_baseUrl/getReclam');

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
      String titre, String description, String categorie, String creerpar) async {
    try {
      ReclamationRequest request = ReclamationRequest(
        titre: titre,
        categorie: categorie,
        description: description,
        creerpar: creerpar,
      );

      final response = await _dio.post(
        '$_baseUrl/addReclamation',
        data: request.toJson(),
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

  Future<ReclamationResponse> updateStatus(int id, String status) async {
    try {
      StatusUpdateRequest request = StatusUpdateRequest(status: status);

      final response = await _dio.put(
        '$_baseUrl/updateStatus/$id',
        data: request.toJson(),
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
      final response = await _dio.delete('$_baseUrl/deleteReclam/$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete reclamation');
      }
    } catch (e) {
      throw Exception('Error deleting reclamation: $e');
    }
  }

  Future<CommentResponse> addComment(int id, String author, String text) async {
    try {
      CommentRequest request = CommentRequest(author: author, text: text);

      final response = await _dio.post(
        '$_baseUrl/addComment/$id',
        data: request.toJson(),
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
