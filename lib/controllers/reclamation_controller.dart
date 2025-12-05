import 'package:codajoy/models/reclamation_model.dart';
import 'package:codajoy/services/reclamation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReclamationController extends GetxController {
  final ReclamationService _service = MockReclamationService();

  var isLoading = false.obs;

  // All items
  var reclamationList = <Reclamation>[].obs;

  // Filtered items for display
  var filteredList = <Reclamation>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchReclamations();

    // Listen to search changes
    searchController.addListener(() {
      filter(searchController.text);
    });
  }

  void filter(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(reclamationList);
    } else {
      var lowerQuery = query.toLowerCase();
      var results = reclamationList.where((item) {
        return item.title.toLowerCase().contains(lowerQuery) ||
            item.status.toLowerCase().contains(lowerQuery) ||
            item.category.toLowerCase().contains(lowerQuery);
      }).toList();
      filteredList.assignAll(results);
    }
  }

  Future<void> fetchReclamations() async {
    try {
      isLoading(true);
      var fetched = await _service.getReclamations();
      reclamationList.assignAll(fetched);
      filter(searchController.text); // Re-apply filter if any
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addReclamation(
      String title, String description, String category) async {
    try {
      isLoading(true);
      bool success =
          await _service.createReclamation(title, description, category);
      if (success) {
        await fetchReclamations(); // Refresh list
        return true;
      }
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateStatus(String id, String newStatus) async {
    try {
      isLoading(true);
      var success = await _service.updateReclamation(id, newStatus);
      if (success) {
        await fetchReclamations();
        Get.snackbar("Success", "Status updated successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1));
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteReclamation(String id) async {
    try {
      isLoading(true);
      var success = await _service.deleteReclamation(id);
      if (success) {
        await fetchReclamations();
        Get.snackbar("Deleted", "Ticket removed",
            snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addComment(String id, String text) async {
    try {
      isLoading(true);
      var success = await _service.addComment(id, text);
      if (success) {
        await fetchReclamations();
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
