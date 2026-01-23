import 'package:codajoy/models/forum_model.dart';
import 'package:codajoy/services/forum_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForumController extends GetxController {
  final ForumService forumService;

  ForumController({ForumService? forumService})
      : forumService = forumService ?? ApiForumService();

  // Observable variables
  final RxList<ForumQuestion> questions = <ForumQuestion>[].obs;
  final RxList<ForumQuestion> filteredQuestions = <ForumQuestion>[].obs;
  final Rxn<ForumQuestion> selectedQuestion = Rxn<ForumQuestion>();
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = "Tous".obs;

  // Search controller
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadQuestions();

    // Listen to search changes
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    // Recharger les questions avec la recherche
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      isLoading.value = true;

      // Convertir le filtre local en filtre backend
      String? backendFilter;
      switch (selectedFilter.value) {
        case "Sans réponse":
          backendFilter = "unanswered";
          break;
        case "Résolu":
          backendFilter = "resolved";
          break;
        case "Récent":
          backendFilter = "recent";
          break;
        default:
          backendFilter = null;
      }

      // Appeler le backend avec les filtres
      final result = await forumService.getQuestions(
        filter: backendFilter,
        search: searchController.text.isNotEmpty ? searchController.text : null,
      );

      questions.value = result;
      filteredQuestions.value = result;
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible de charger les questions",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadQuestionById(String id) async {
    try {
      final result = await forumService.getQuestionById(id);
      if (result != null) {
        selectedQuestion.value = result;
        await forumService.incrementViews(id);
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible de charger la question",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> createQuestion(
      String title, String description, List<String> tags) async {
    try {
      isLoading.value = true;
      print('=== ForumController: Creating question ===');
      final success = await forumService.createQuestion(title, description, tags);

      print('Create question result: $success');

      if (success) {
        Get.snackbar(
          "Succès",
          "Question créée avec succès!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Reload questions and go back to forum list
        print('Reloading questions...');
        await loadQuestions();
        print('Navigating back to ForumListScreen...');
        Get.back();
      } else {
        throw Exception("Failed to create question");
      }
    } catch (e) {
      print('Error in createQuestion: $e');
      Get.snackbar(
        "Erreur",
        "Impossible de créer la question",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAnswer(String questionId, String content) async {
    try {
      final success = await forumService.addAnswer(questionId, content);

      if (success) {
        Get.snackbar(
          "Succès",
          "Réponse ajoutée avec succès!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Reload the question
        await loadQuestionById(questionId);
      } else {
        throw Exception("Failed to add answer");
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible d'ajouter la réponse",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> voteQuestion(String questionId, bool isUpvote) async {
    try {
      final success = await forumService.voteQuestion(questionId, isUpvote);

      if (success) {
        // Reload the question
        await loadQuestionById(questionId);
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible de voter",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> voteAnswer(String answerId, bool isUpvote) async {
    try {
      final success = await forumService.voteAnswer(answerId, isUpvote);

      if (success && selectedQuestion.value != null) {
        // Reload the question
        await loadQuestionById(selectedQuestion.value!.id);
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible de voter",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> acceptAnswer(String answerId) async {
    try {
      final success = await forumService.acceptAnswer(answerId);

      if (success) {
        Get.snackbar(
          "Succès",
          "Réponse acceptée!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (selectedQuestion.value != null) {
          // Reload the question
          await loadQuestionById(selectedQuestion.value!.id);
        }
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        "Impossible d'accepter la réponse",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    loadQuestions(); // Recharger avec le nouveau filtre depuis le backend
  }
}
