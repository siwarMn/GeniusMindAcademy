import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReclamationStatsScreen extends StatelessWidget {
  ReclamationStatsScreen({Key? key}) : super(key: key);

  final ReclamationController controller = Get.find<ReclamationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques"),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var totalReclamations = controller.reclamationList.length;
        var openReclamations = controller.reclamationList
            .where((r) => r.status.toLowerCase() == 'open')
            .length;
        var inProgressReclamations = controller.reclamationList
            .where((r) => r.status.toLowerCase() == 'in progress')
            .length;
        var resolvedReclamations = controller.reclamationList
            .where((r) => r.status.toLowerCase() == 'resolved')
            .length;
        var closedReclamations = controller.reclamationList
            .where((r) => r.status.toLowerCase() == 'closed')
            .length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatCard(
                  'Total Réclamations', totalReclamations.toString(), Colors.blue),
              const SizedBox(height: 16),
              _buildStatCard('Ouvertes', openReclamations.toString(), Colors.orange),
              const SizedBox(height: 16),
              _buildStatCard(
                  'En Cours', inProgressReclamations.toString(), Colors.purple),
              const SizedBox(height: 16),
              _buildStatCard(
                  'Résolues', resolvedReclamations.toString(), Colors.green),
              const SizedBox(height: 16),
              _buildStatCard('Fermées', closedReclamations.toString(), Colors.grey),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
