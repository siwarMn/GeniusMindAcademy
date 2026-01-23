import 'package:codajoy/models/reclamation_model.dart';
import 'package:codajoy/services/reclamation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReclamationController extends GetxController {
  final ReclamationService _service = ReclamationService();

  var isLoading = false.obs;

  var reclamationList = <ReclamationResponse>[].obs;
  var filteredList = <ReclamationResponse>[].obs;

  final TextEditingController searchController = TextEditingController();

  var selectedStatus = 'All'.obs;
  var selectedCategory = 'All'.obs;
  var selectedPriority = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReclamations();

    searchController.addListener(() {
      applyFilters();
    });
  }

  void filter(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(reclamationList);
    } else {
      var lowerQuery = query.toLowerCase();
      var results = reclamationList.where((item) {
        return item.titre.toLowerCase().contains(lowerQuery) ||
            item.status.toLowerCase().contains(lowerQuery) ||
            item.categorie.toLowerCase().contains(lowerQuery);
      }).toList();
      filteredList.assignAll(results);
    }
  }

  void applyFilters() {
    var results = reclamationList.where((item) {
      bool matchesSearch = searchController.text.isEmpty ||
          item.titre.toLowerCase().contains(searchController.text.toLowerCase()) ||
          item.status.toLowerCase().contains(searchController.text.toLowerCase()) ||
          item.categorie.toLowerCase().contains(searchController.text.toLowerCase());

      bool matchesStatus = selectedStatus.value == 'All' ||
          item.status.toLowerCase() == selectedStatus.value.toLowerCase();

      bool matchesCategory = selectedCategory.value == 'All' ||
          item.categorie.toLowerCase() == selectedCategory.value.toLowerCase();

      bool matchesPriority = selectedPriority.value == 'All' ||
          (item.priority?.toLowerCase() == selectedPriority.value.toLowerCase());

      return matchesSearch && matchesStatus && matchesCategory && matchesPriority;
    }).toList();

    filteredList.assignAll(results);
  }

  Future<void> fetchReclamations() async {
    try {
      isLoading(true);
      var fetched = await _service.getReclamations();
      reclamationList.assignAll(fetched);
      filter(searchController.text);
    } catch (e) {
      _showSafeSnackbar("Error", "Failed to load reclamations: $e",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addReclamation(
      String titre, String description, String categorie, String priority) async {
    try {
      isLoading(true);
      await _service.createReclamation(titre, description, categorie, "User", priority);
      await fetchReclamations();
      return true;
    } catch (e) {
      _showSafeSnackbar("Error", "Failed to create reclamation: $e",
          backgroundColor: Colors.red);
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> assignReclamation(int id, String assignedTo) async {
    try {
      isLoading(true);
      await _service.assignReclamation(id, assignedTo);
      await fetchReclamations();
      _showSafeSnackbar("Success", "Reclamation assigned successfully",
          backgroundColor: Colors.green);
    } catch (e) {
      _showSafeSnackbar("Error", "Failed to assign reclamation: $e",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> rateReclamation(int id, int rating) async {
    try {
      isLoading(true);
      await _service.rateReclamation(id, rating);
      await fetchReclamations();
      _showSafeSnackbar("Success", "Thank you for your feedback!",
          backgroundColor: Colors.green);
    } catch (e) {
      _showSafeSnackbar("Error", "Failed to rate reclamation: $e",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateStatus(int id, String newStatus) async {
    try {
      isLoading(true);
      await _service.updateStatus(id, newStatus);
      await fetchReclamations();
      _showSafeSnackbar("Success", "Status updated successfully",
          backgroundColor: Colors.green);
    } catch (e) {
      _showSafeSnackbar("Error", "Failed to update status: $e",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteReclamation(int id) async {
    try {
      isLoading(true);
      await _service.deleteReclamation(id);
      await fetchReclamations();
      _showSafeSnackbar("Deleted", "Ticket removed");
    } catch (e) {
      _showSafeSnackbar("Error", "Failed to delete reclamation: $e",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addComment(int id, String text) async {
    try {
      isLoading(true);
      await _service.addComment(id, "User", text);
      await fetchReclamations();
    } catch (e) {
      _showSafeSnackbar("Error", "Failed to add comment: $e",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _showSafeSnackbar(String title, String message,
      {Color? backgroundColor}) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("$title: $message"),
          backgroundColor: backgroundColor ?? Colors.grey[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
