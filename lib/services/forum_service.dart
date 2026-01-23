import 'package:codajoy/models/forum_model.dart';
import 'package:codajoy/config/api_config.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ForumService {
  Future<List<ForumQuestion>> getQuestions({
    String? filter, // 'unanswered', 'resolved', 'recent'
    String? search,
    String? tag,
  });
  Future<ForumQuestion?> getQuestionById(String id);
  Future<bool> createQuestion(String title, String description, List<String> tags);
  Future<bool> addAnswer(String questionId, String content);
  Future<bool> voteQuestion(String questionId, bool isUpvote);
  Future<bool> voteAnswer(String answerId, bool isUpvote);
  Future<bool> acceptAnswer(String answerId);
  Future<bool> incrementViews(String questionId);
}

class MockForumService implements ForumService {
  final List<ForumQuestion> _mockQuestions = [
    ForumQuestion(
      id: "1",
      title: "Comment intégrer Firebase dans Flutter?",
      description: "Je débute avec Flutter et j'aimerais savoir comment intégrer Firebase Authentication et Firestore dans mon application. Quelqu'un peut-il m'aider avec les étapes?",
      author: "Mohamed Ali",
      tags: ["Flutter", "Firebase", "Débutant"],
      votes: 15,
      views: 234,
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      upvotedBy: ["user1", "user2"],
      answers: [
        ForumAnswer(
          id: "a1",
          questionId: "1",
          author: "Sara Ben Ahmed",
          content: "Pour intégrer Firebase:\n\n1. Ajoutez les dépendances dans pubspec.yaml:\n```yaml\nfirebase_core: ^2.4.0\nfirebase_auth: ^4.2.0\ncloud_firestore: ^4.3.0\n```\n\n2. Configurez Firebase dans votre projet\n3. Initialisez Firebase dans main.dart:\n```dart\nawait Firebase.initializeApp();\n```\n\nVoilà! Vous êtes prêt à utiliser Firebase.",
          votes: 8,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          isAccepted: true,
          upvotedBy: ["user1"],
        ),
        ForumAnswer(
          id: "a2",
          questionId: "1",
          author: "Ahmed Khaled",
          content: "N'oubliez pas aussi de configurer les fichiers google-services.json (Android) et GoogleService-Info.plist (iOS)!",
          votes: 3,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
      ],
    ),
    ForumQuestion(
      id: "2",
      title: "Quelle est la différence entre StatefulWidget et StatelessWidget?",
      description: "Je suis confus sur quand utiliser StatefulWidget vs StatelessWidget. Quelqu'un peut expliquer avec des exemples?",
      author: "Fatima Zahra",
      tags: ["Flutter", "Widgets", "Débutant"],
      votes: 23,
      views: 567,
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      upvotedBy: ["user1", "user2", "user3"],
      answers: [
        ForumAnswer(
          id: "a3",
          questionId: "2",
          author: "Youssef Ben Salah",
          content: "StatelessWidget: Utilisez-le quand le widget ne change pas.\n\nStatefulWidget: Utilisez-le quand vous avez besoin de gérer un état qui peut changer (comme un compteur, un formulaire, etc.).\n\nExemple: Un bouton qui affiche un texte statique = StatelessWidget. Un compteur qui s'incrémente = StatefulWidget.",
          votes: 18,
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          isAccepted: true,
          upvotedBy: ["user1", "user2"],
        ),
      ],
    ),
    ForumQuestion(
      id: "3",
      title: "Problème de performance avec ListView",
      description: "Mon ListView avec 1000+ items est très lent. Comment puis-je optimiser les performances?",
      author: "Karim Mansour",
      tags: ["Flutter", "Performance", "ListView"],
      votes: 12,
      views: 189,
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      upvotedBy: ["user1"],
      answers: [],
    ),
    ForumQuestion(
      id: "4",
      title: "Comment gérer la navigation avec GetX?",
      description: "Je veux utiliser GetX pour la navigation dans mon app. Quelles sont les meilleures pratiques?",
      author: "Nadia Elmahdi",
      tags: ["Flutter", "GetX", "Navigation"],
      votes: 8,
      views: 145,
      createdAt: DateTime.now().subtract(Duration(hours: 6)),
      answers: [
        ForumAnswer(
          id: "a4",
          questionId: "4",
          author: "Hassan Rami",
          content: "Avec GetX, utilisez simplement:\n\nGet.to(() => NewPage());\n\nPour passer des paramètres:\nGet.to(() => NewPage(), arguments: {'id': 123});\n\nEt pour récupérer:\nfinal args = Get.arguments;",
          votes: 5,
          createdAt: DateTime.now().subtract(Duration(hours: 4)),
        ),
      ],
    ),
  ];

  @override
  Future<List<ForumQuestion>> getQuestions({
    String? filter,
    String? search,
    String? tag,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return List.from(_mockQuestions);
  }

  @override
  Future<ForumQuestion?> getQuestionById(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      return _mockQuestions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> createQuestion(String title, String description, List<String> tags) async {
    await Future.delayed(Duration(seconds: 1));
    _mockQuestions.insert(
      0,
      ForumQuestion(
        id: Random().nextInt(10000).toString(),
        title: title,
        description: description,
        author: "Current User", // TODO: Get from auth
        tags: tags,
        votes: 0,
        views: 0,
        createdAt: DateTime.now(),
        answers: [],
      ),
    );
    return true;
  }

  @override
  Future<bool> addAnswer(String questionId, String content) async {
    await Future.delayed(Duration(seconds: 1));
    final index = _mockQuestions.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      final question = _mockQuestions[index];
      final newAnswer = ForumAnswer(
        id: "a${Random().nextInt(10000)}",
        questionId: questionId,
        author: "Current User", // TODO: Get from auth
        content: content,
        votes: 0,
        createdAt: DateTime.now(),
      );

      final updatedAnswers = List<ForumAnswer>.from(question.answers)..add(newAnswer);

      _mockQuestions[index] = ForumQuestion(
        id: question.id,
        title: question.title,
        description: question.description,
        author: question.author,
        tags: question.tags,
        votes: question.votes,
        views: question.views,
        createdAt: question.createdAt,
        answers: updatedAnswers,
        upvotedBy: question.upvotedBy,
        downvotedBy: question.downvotedBy,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> voteQuestion(String questionId, bool isUpvote) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _mockQuestions.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      final question = _mockQuestions[index];
      final newVotes = question.votes + (isUpvote ? 1 : -1);

      _mockQuestions[index] = ForumQuestion(
        id: question.id,
        title: question.title,
        description: question.description,
        author: question.author,
        tags: question.tags,
        votes: newVotes,
        views: question.views,
        createdAt: question.createdAt,
        answers: question.answers,
        upvotedBy: question.upvotedBy,
        downvotedBy: question.downvotedBy,
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> voteAnswer(String answerId, bool isUpvote) async {
    await Future.delayed(Duration(milliseconds: 300));
    for (var i = 0; i < _mockQuestions.length; i++) {
      final question = _mockQuestions[i];
      final answerIndex = question.answers.indexWhere((a) => a.id == answerId);

      if (answerIndex != -1) {
        final answer = question.answers[answerIndex];
        final newVotes = answer.votes + (isUpvote ? 1 : -1);

        final updatedAnswers = List<ForumAnswer>.from(question.answers);
        updatedAnswers[answerIndex] = ForumAnswer(
          id: answer.id,
          questionId: answer.questionId,
          author: answer.author,
          content: answer.content,
          votes: newVotes,
          createdAt: answer.createdAt,
          isAccepted: answer.isAccepted,
          upvotedBy: answer.upvotedBy,
          downvotedBy: answer.downvotedBy,
        );

        _mockQuestions[i] = ForumQuestion(
          id: question.id,
          title: question.title,
          description: question.description,
          author: question.author,
          tags: question.tags,
          votes: question.votes,
          views: question.views,
          createdAt: question.createdAt,
          answers: updatedAnswers,
          upvotedBy: question.upvotedBy,
          downvotedBy: question.downvotedBy,
        );
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> acceptAnswer(String answerId) async {
    await Future.delayed(Duration(milliseconds: 300));
    for (var i = 0; i < _mockQuestions.length; i++) {
      final question = _mockQuestions[i];
      final answerIndex = question.answers.indexWhere((a) => a.id == answerId);

      if (answerIndex != -1) {
        final updatedAnswers = question.answers.map((answer) {
          return ForumAnswer(
            id: answer.id,
            questionId: answer.questionId,
            author: answer.author,
            content: answer.content,
            votes: answer.votes,
            createdAt: answer.createdAt,
            isAccepted: answer.id == answerId,
            upvotedBy: answer.upvotedBy,
            downvotedBy: answer.downvotedBy,
          );
        }).toList();

        _mockQuestions[i] = ForumQuestion(
          id: question.id,
          title: question.title,
          description: question.description,
          author: question.author,
          tags: question.tags,
          votes: question.votes,
          views: question.views,
          createdAt: question.createdAt,
          answers: updatedAnswers,
          upvotedBy: question.upvotedBy,
          downvotedBy: question.downvotedBy,
        );
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> incrementViews(String questionId) async {
    final index = _mockQuestions.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      final question = _mockQuestions[index];
      _mockQuestions[index] = ForumQuestion(
        id: question.id,
        title: question.title,
        description: question.description,
        author: question.author,
        tags: question.tags,
        votes: question.votes,
        views: question.views + 1,
        createdAt: question.createdAt,
        answers: question.answers,
        upvotedBy: question.upvotedBy,
        downvotedBy: question.downvotedBy,
      );
      return true;
    }
    return false;
  }
}

// ============================================================================
// API Forum Service - Connexion avec le backend Spring Boot
// ============================================================================

class ApiForumService implements ForumService {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ForumQuestion>> getQuestions({
    String? filter,
    String? search,
    String? tag,
  }) async {
    try {
      final url = ApiConfig.getQuestionsWithFilter(
        filter: filter,
        search: search,
        tag: tag,
      );

      final response = await http.get(
        Uri.parse(url),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => _questionFromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching questions: $e');
      rethrow;
    }
  }

  @override
  Future<ForumQuestion?> getQuestionById(String id) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getQuestionById(id)),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return _questionFromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load question: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question: $e');
      return null;
    }
  }

  @override
  Future<bool> createQuestion(
      String title, String description, List<String> tags) async {
    try {
      print('=== FLUTTER: Creating question ===');
      print('Title: $title');
      print('Description: $description');
      print('Tags: $tags');

      final response = await http.post(
        Uri.parse(ApiConfig.forumQuestions),
        headers: await _headers(),
        body: json.encode({
          'title': title,
          'description': description,
          'tags': tags,
          'author': 'Current User', // TODO: Récupérer depuis l'auth
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error creating question: $e');
      return false;
    }
  }

  @override
  Future<bool> addAnswer(String questionId, String content) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.forumAnswers),
        headers: await _headers(),
        body: json.encode({
          'questionId': questionId.startsWith(RegExp(r'^\d+$')) ? int.parse(questionId) : questionId,
          'content': content,
          'author': 'Current User', // TODO: Récupérer depuis l'auth
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error adding answer: $e');
      return false;
    }
  }

  @override
  Future<bool> voteQuestion(String questionId, bool isUpvote) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.voteQuestion(questionId)),
        headers: await _headers(),
        body: json.encode({
          'isUpvote': isUpvote,
          'userId': 'user123', // TODO: Récupérer l'ID depuis l'auth
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error voting question: $e');
      return false;
    }
  }

  @override
  Future<bool> voteAnswer(String answerId, bool isUpvote) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.voteAnswer(answerId)),
        headers: await _headers(),
        body: json.encode({
          'isUpvote': isUpvote,
          'userId': 'user123', // TODO: Récupérer l'ID depuis l'auth
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error voting answer: $e');
      return false;
    }
  }

  @override
  Future<bool> acceptAnswer(String answerId) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.acceptAnswer(answerId)),
        headers: await _headers(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error accepting answer: $e');
      return false;
    }
  }

  @override
  Future<bool> incrementViews(String questionId) async {
    // Les vues sont automatiquement incrémentées par le backend
    // lors de l'appel à getQuestionById
    return true;
  }

  // Helper methods pour convertir JSON en objets Dart
  ForumQuestion _questionFromJson(Map<String, dynamic> json) {
    return ForumQuestion(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['content'] ?? json['description'] ?? '', // Backend uses 'content'
      author: json['author'] ?? 'Unknown',
      tags: List<String>.from(json['tags'] ?? []),
      votes: json['votes'] ?? 0,
      views: json['views'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => _answerFromJson(a))
              .toList() ??
          [],
      upvotedBy: List<String>.from(json['upvotedBy'] ?? []),
      downvotedBy: List<String>.from(json['downvotedBy'] ?? []),
    );
  }

  ForumAnswer _answerFromJson(Map<String, dynamic> json) {
    return ForumAnswer(
      id: json['id'].toString(),
      questionId: json['questionId']?.toString() ?? '',
      author: json['author'] ?? 'Unknown',
      content: json['content'] ?? '',
      votes: json['votes'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isAccepted: json['isAccepted'] ?? false,
      upvotedBy: List<String>.from(json['upvotedBy'] ?? []),
      downvotedBy: List<String>.from(json['downvotedBy'] ?? []),
    );
  }
}
