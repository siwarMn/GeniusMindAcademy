import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/flashcard_api_model.dart';

class FlashcardsApi {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  FlashcardsApi(String baseUrl)
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<List<FlashcardApiModel>> list() async {
    final res = await _dio.get('/api/flashcards');
    // Spring Page -> content array
    final List content = res.data['content'] as List;
    return content.map((e) => FlashcardApiModel.fromJson(e)).toList();
  }

  Future<FlashcardApiModel> create({
    required String front,
    required String back,
    required String category,
  }) async {
    final res = await _dio.post('/api/flashcards', data: {
      'front': front,
      'back': back,
      'category': category,
      'memorized': false,
    });
    return FlashcardApiModel.fromJson(res.data);
  }

  Future<FlashcardApiModel> update({
    required int id,
    required String front,
    required String back,
    required String category,
    required bool memorized,
  }) async {
    final res = await _dio.put('/api/flashcards/$id', data: {
      'front': front,
      'back': back,
      'category': category,
      'memorized': memorized,
    });
    return FlashcardApiModel.fromJson(res.data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/api/flashcards/$id');
  }
}
