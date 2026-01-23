import 'dart:typed_data';
import 'package:codajoy/models/course_model.dart';
import 'package:codajoy/services/courses_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller to manage courses list
class CoursesListController extends GetxController {
  final CoursesService _service = CoursesService();

  // Observable variables
  var isLoading = false.obs;
  var courses = <Course>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  // Fetch all courses from backend
  Future<void> fetchCourses() async {
    try {
      isLoading(true);
      var fetched = await _service.getCourses();
      courses.assignAll(fetched);
    } catch (e) {
      _showMessage("Erreur", "Impossible de charger les cours");
    } finally {
      isLoading(false);
    }
  }

  // Upload a new PDF file
  Future<void> uploadFile(Uint8List fileBytes, String fileName) async {
    try {
      isLoading(true);
      bool success = await _service.uploadFile(fileBytes, fileName);
      if (success) {
        _showMessage("Succes", "Fichier ajoute");
        await fetchCourses();
      } else {
        _showMessage("Erreur", "Impossible d'ajouter le fichier");
      }
    } catch (e) {
      _showMessage("Erreur", "Impossible d'ajouter le fichier");
    } finally {
      isLoading(false);
    }
  }

  // Delete a file
  Future<void> deleteFile(int fileId) async {
    try {
      isLoading(true);
      bool success = await _service.deleteFile(fileId);
      if (success) {
        _showMessage("Succes", "Fichier supprime");
        await fetchCourses();
      } else {
        _showMessage("Erreur", "Impossible de supprimer");
      }
    } catch (e) {
      _showMessage("Erreur", "Impossible de supprimer");
    } finally {
      isLoading(false);
    }
  }

  // Show a message
  void _showMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: title == "Succes" ? Colors.green[100] : Colors.red[100],
    );
  }
}
