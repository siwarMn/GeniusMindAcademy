import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/flashcard_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlashcardController extends GetxController {
  static const String _baseUrl = 'http://127.0.0.1:8080';

  final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final cards = <Flashcard>[].obs;
  final loading = false.obs;

  // filters
  final RxString categoryFilter = ''.obs;     // '' = all
  final RxString searchFilter = ''.obs;       // '' = none
  final RxBool unmemorizedOnly = false.obs;   // 👎 only

  @override
  void onInit() {
    super.onInit();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token'); // ✅ use this
          debugPrint('TOKEN READ = ${token?.substring(0, 20)}...'); // debug

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          debugPrint('REQUEST ${options.method} ${options.uri}');
          debugPrint('HEADERS: ${options.headers}');
          handler.next(options);
        },
      ),
    );

    refreshList();
  }

  Future<void> refreshList() async {
    loading.value = true;
    try {
      final res = await _dio.get('/api/v1/flashcards');

      // Spring Page response: { content: [...], ... }
      final List content = (res.data is Map && res.data['content'] is List)
          ? (res.data['content'] as List)
          : (res.data as List); // in case you return plain list

      final parsed = content.map((e) => Flashcard.fromJson(e)).toList();
      cards.assignAll(parsed);
    } catch (e) {
      // Get.snackbar('Flashcards', 'Failed to load flashcards');
      debugPrint('Failed to load flashcards error: $e');


    } finally {
      loading.value = false;
    }
  }

  Future<void> addCard(String front, String back, String category) async {
    try {
      final res = await _dio.post('/api/v1/flashcards', data: {
        'front': front,
        'back': back,
        'category': category,
        'memorized': false,
      });

      final created = Flashcard.fromJson(res.data);
      cards.add(created);
    } catch (e) {
      // Get.snackbar('Flashcards', 'Failed to create flashcard');
      debugPrint('Failed to create flashcard error: $e');

    }
  }

  Future<void> updateCard(int id, String front, String back, String category) async {
    final existing = cards.firstWhereOrNull((c) => c.id == id);
    if (existing == null) return;

    try {
      final res = await _dio.put('/api/v1/flashcards/$id', data: {
        'front': front,
        'back': back,
        'category': category,
        'memorized': existing.memorized,
      });

      final updated = Flashcard.fromJson(res.data);
      final index = cards.indexWhere((c) => c.id == id);
      if (index != -1) cards[index] = updated;
    } catch (e) {
      // Get.snackbar('Flashcards', 'Failed to update flashcard');
            debugPrint('Failed to update flashcard error: $e');

    }
  }

  Future<void> deleteCard(int id) async {
    try {
      await _dio.delete('/api/v1/flashcards/$id');
      cards.removeWhere((c) => c.id == id);
    } catch (e) {
      // Get.snackbar('Flashcards', 'Failed to delete flashcard');
            debugPrint('Failed to delete flashcards error: $e');

    }
  }

  Flashcard? getById(int id) => cards.firstWhereOrNull((c) => c.id == id);

  Future<void> markKnown(int id) async {
    final existing = getById(id);
    if (existing == null) return;

    try {
      final res = await _dio.put('/api/v1/flashcards/$id', data: {
        'front': existing.front,
        'back': existing.back,
        'category': existing.category,
        'memorized': true,
      });

      final updated = Flashcard.fromJson(res.data);
      final index = cards.indexWhere((c) => c.id == id);
      if (index != -1) cards[index] = updated;
    } catch (e) {
      // Get.snackbar('Flashcards', 'Failed to mark as memorized');
            debugPrint('Failed to mark memo flashcards error: $e');

    }
  }

  Future<void> markUnknown(int id) async {
    final existing = getById(id);
    if (existing == null) return;

    try {
      final res = await _dio.put('/api/v1/flashcards/$id', data: {
        'front': existing.front,
        'back': existing.back,
        'category': existing.category,
        'memorized': false,
      });

      final updated = Flashcard.fromJson(res.data);
      final index = cards.indexWhere((c) => c.id == id);
      if (index != -1) cards[index] = updated;
    } catch (e) {
      // Get.snackbar('Flashcards', 'Failed to mark as unmemorized');
            debugPrint('Failed to mark unmemo flashcards error: $e');

    }
  }

  // UI helpers
  List<String> get availableCategories =>
      (cards.map((c) => c.category).toSet().toList()..sort());

  List<Flashcard> get filteredCards {
    final q = searchFilter.value.toLowerCase();

    return cards.where((c) {
      final matchCategory =
          categoryFilter.value.isEmpty || c.category == categoryFilter.value;

      final matchSearch =
          q.isEmpty ||
          c.front.toLowerCase().contains(q) ||
          c.back.toLowerCase().contains(q);

      final matchUnmemo = !unmemorizedOnly.value || !c.memorized;

      return matchCategory && matchSearch && matchUnmemo;
    }).toList();
  }

  void setCategoryFilter(String? category) => categoryFilter.value = category ?? '';
  void setSearchFilter(String value) => searchFilter.value = value;
  void setUnmemorizedOnly(bool value) => unmemorizedOnly.value = value;
}
