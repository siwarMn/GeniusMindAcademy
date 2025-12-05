import 'package:codajoy/models/reclamation_model.dart';
import 'dart:math';

abstract class ReclamationService {
  Future<List<Reclamation>> getReclamations();
  Future<bool> createReclamation(
      String title, String description, String category);
  Future<bool> updateReclamation(String id, String newStatus);
  Future<bool> deleteReclamation(String id);
  Future<bool> addComment(String id, String text);
}

class MockReclamationService implements ReclamationService {
  // In-memory list to simulate backend storage during session
  final List<Reclamation> _mockDb = [
    Reclamation(
      id: "1",
      title: "Problème de connexion",
      description:
          "Je n'arrive pas à me connecter à mon compte depuis ce matin.",
      category: "Compte",
      status: "Resolved",
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Reclamation(
      id: "2",
      title: "PDF ne charge pas",
      description: "Le cours de Mathématiques 7ème est vide.",
      category: "Technique",
      status: "In Progress",
      createdAt: DateTime.now().subtract(Duration(hours: 4)),
    ),
  ];

  @override
  Future<List<Reclamation>> getReclamations() async {
    await Future.delayed(Duration(seconds: 1)); // Network delay
    // Return copy to pretend it's fresh
    return List.from(_mockDb);
  }

  @override
  Future<bool> createReclamation(
      String title, String description, String category) async {
    await Future.delayed(Duration(seconds: 1));
    _mockDb.insert(
        0,
        Reclamation(
          id: Random().nextInt(1000).toString(),
          title: title,
          description: description,
          category: category,
          status: "Open",
          createdAt: DateTime.now(),
        ));
    return true;
  }

  @override
  Future<bool> updateReclamation(String id, String newStatus) async {
    await Future.delayed(Duration(seconds: 1));
    final index = _mockDb.indexWhere((element) => element.id == id);
    if (index != -1) {
      var old = _mockDb[index];
      _mockDb[index] = Reclamation(
          id: old.id,
          title: old.title,
          description: old.description,
          category: old.category,
          status: newStatus,
          createdAt: old.createdAt,
          comments: old.comments);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteReclamation(String id) async {
    await Future.delayed(Duration(seconds: 1));
    _mockDb.removeWhere((element) => element.id == id);
    return true;
  }

  @override
  Future<bool> addComment(String id, String text) async {
    await Future.delayed(Duration(seconds: 1));
    final index = _mockDb.indexWhere((element) => element.id == id);
    if (index != -1) {
      var old = _mockDb[index];
      var newComments = List<ReclamationComment>.from(old.comments);
      newComments.add(ReclamationComment(
        author: "User", // Hardcoded for now, or fetch from UserService
        text: text,
        date: DateTime.now(),
      ));

      _mockDb[index] = Reclamation(
          id: old.id,
          title: old.title,
          description: old.description,
          category: old.category,
          status: old.status,
          createdAt: old.createdAt,
          comments: newComments);
      return true;
    }
    return false;
  }
}
