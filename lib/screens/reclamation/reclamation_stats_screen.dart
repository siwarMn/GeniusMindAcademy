import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Screen that shows statistics about reclamations/tickets
// Shows counts by status, category, and priority
class ReclamationStatsScreen extends StatelessWidget {
  ReclamationStatsScreen({Key? key}) : super(key: key);

  // Get the controller
  final ReclamationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: const Text("Statistiques"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        // Show loading
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Get the list of reclamations
        var list = controller.reclamationList;

        // Calculate stats
        int total = list.length;
        int open = list.where((r) => r.status.toLowerCase() == 'open').length;
        int inProgress =
            list.where((r) => r.status.toLowerCase() == 'in progress').length;
        int resolved =
            list.where((r) => r.status.toLowerCase() == 'resolved').length;
        int closed =
            list.where((r) => r.status.toLowerCase() == 'closed').length;

        // Count by category
        Map<String, int> categoryCount = {};
        for (var r in list) {
          categoryCount[r.categorie] = (categoryCount[r.categorie] ?? 0) + 1;
        }

        // Count by priority
        int low = list.where((r) => r.priority?.toLowerCase() == 'low').length;
        int medium =
            list.where((r) => r.priority?.toLowerCase() == 'medium').length;
        int high =
            list.where((r) => r.priority?.toLowerCase() == 'high').length;
        int critical =
            list.where((r) => r.priority?.toLowerCase() == 'critical').length;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total count card
              _buildTotalCard(total),

              SizedBox(height: 20),

              // Status section
              Text(
                "Par Statut",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Ouvert",
                      open,
                      Colors.orange,
                      Icons.fiber_new,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "En cours",
                      inProgress,
                      Colors.blue,
                      Icons.hourglass_empty,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Resolu",
                      resolved,
                      Colors.green,
                      Icons.check_circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Ferme",
                      closed,
                      Colors.grey,
                      Icons.archive,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Status progress bar
              Text(
                "Progression",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              _buildProgressBar(total, open, inProgress, resolved, closed),

              SizedBox(height: 24),

              // Priority section
              Text(
                "Par Priorite",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildPriorityCard("Low", low, Colors.green),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildPriorityCard("Medium", medium, Colors.orange),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child:
                        _buildPriorityCard("High", high, Colors.deepOrange),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildPriorityCard("Critical", critical, Colors.red),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Category section
              Text(
                "Par Categorie",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              ...categoryCount.entries.map((entry) {
                return _buildCategoryRow(entry.key, entry.value, total);
              }).toList(),

              SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // Build the total count card at the top
  Widget _buildTotalCard(int total) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.confirmation_number,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(height: 12),
          Text(
            total.toString(),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "Total des tickets",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Build a stat card for status
  Widget _buildStatCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 10),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Build a priority card
  Widget _buildPriorityCard(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Build progress bar showing status distribution
  Widget _buildProgressBar(
      int total, int open, int inProgress, int resolved, int closed) {
    if (total == 0) {
      return Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Aucune donnee",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                if (open > 0)
                  Expanded(
                    flex: open,
                    child: Container(height: 16, color: Colors.orange),
                  ),
                if (inProgress > 0)
                  Expanded(
                    flex: inProgress,
                    child: Container(height: 16, color: Colors.blue),
                  ),
                if (resolved > 0)
                  Expanded(
                    flex: resolved,
                    child: Container(height: 16, color: Colors.green),
                  ),
                if (closed > 0)
                  Expanded(
                    flex: closed,
                    child: Container(height: 16, color: Colors.grey),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem("Ouvert", Colors.orange),
              _buildLegendItem("En cours", Colors.blue),
              _buildLegendItem("Resolu", Colors.green),
              _buildLegendItem("Ferme", Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  // Build legend item
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Build category row with progress bar
  Widget _buildCategoryRow(String category, int count, int total) {
    double percentage = total > 0 ? (count / total) : 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "$count (${(percentage * 100).toStringAsFixed(0)}%)",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: AppTheme.primaryColor,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
