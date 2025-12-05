import 'package:codajoy/screens/courses/courses_list_screen.dart';
import 'package:codajoy/controllers/quiz_controller.dart';
import 'package:codajoy/screens/components/chatbot.dart';
import 'package:codajoy/screens/reclamation/reclamation_list_screen.dart';
import 'package:codajoy/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class ProfileMenuController extends GetxController {
  // Master list of all items
  late List<DashboardItem> _allItems;

  // Observable list for UI
  var filteredItems = <DashboardItem>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeItems();
    filteredItems.assignAll(_allItems);

    // Listen to text changes for search
    searchController.addListener(() {
      filter(searchController.text);
    });
  }

  void _initializeItems() {
    _allItems = [
      DashboardItem(
        title: "Cours",
        icon: Icons.school,
        color: Colors.blue,
        onTap: () => Get.to(() => CoursesListScreen()),
      ),
      DashboardItem(
        title: "Quiz",
        icon: Icons.quiz,
        color: Colors.pinkAccent,
        onTap: () => Get.to(QuizListScreen()),
      ),
      DashboardItem(
        title: "Forums", // Renamed from Tests as per USER edit
        icon: Icons.assignment_turned_in,
        color: Colors.red,
        onTap: () => Get.to(
            QuizListScreen()), // Keeping original destination logic for now
      ),
      DashboardItem(
        title: "Réclamation",
        icon: Icons.report,
        color: Colors.orange,
        onTap: () => Get.to(() => ReclamationListScreen()),
      ),
      DashboardItem(
        title: "Competitions", // Renamed from Chat as per USER edit
        icon: Icons.chat,
        color: Colors.purple,
        onTap: () => Get.to(ChatbotScreen()),
      ),
    ];
  }

  void filter(String query) {
    if (query.isEmpty) {
      filteredItems.assignAll(_allItems);
    } else {
      var lowerQuery = query.toLowerCase();
      var results = _allItems.where((item) {
        return item.title.toLowerCase().contains(lowerQuery);
      }).toList();
      filteredItems.assignAll(results);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
