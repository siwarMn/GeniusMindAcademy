import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:codajoy/models/reclamation_model.dart';
import 'package:codajoy/screens/reclamation/create_reclamation_screen.dart';
import 'package:codajoy/screens/reclamation/reclamation_detail_screen.dart';
import 'package:codajoy/screens/reclamation/reclamation_stats_screen.dart';
import 'package:codajoy/screens/reclamation/widgets/filter_bottom_sheet.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// This screen shows a list of all reclamations/tickets
// User can search, filter, create, edit and delete tickets
class ReclamationListScreen extends StatelessWidget {
  ReclamationListScreen({Key? key}) : super(key: key);

  // Get the controller that manages our data
  final ReclamationController controller = Get.put(ReclamationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        title: const Text(
          "Mes Reclamations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        // Back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        // Action buttons on the right
        actions: [
          // Stats button
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Get.to(() => ReclamationStatsScreen()),
            tooltip: 'Statistiques',
          ),
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Get.bottomSheet(FilterBottomSheet());
            },
            tooltip: 'Filtrer',
          ),
        ],
      ),

      // Background color
      backgroundColor: const Color(0xFFF5F5F5),

      // Floating button to create new ticket
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => CreateReclamationScreen()),
        label: const Text("Nouveau"),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),

      // Main body
      body: Column(
        children: [
          // Header with search and count
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: controller.searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Rechercher un ticket...",
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                SizedBox(height: 16),

                // Ticket count summary
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCountBadge(
                          "Total",
                          controller.reclamationList.length.toString(),
                          Colors.white,
                        ),
                        _buildCountBadge(
                          "Ouvert",
                          controller.reclamationList
                              .where((r) =>
                                  r.status.toLowerCase() == 'open')
                              .length
                              .toString(),
                          Colors.orange,
                        ),
                        _buildCountBadge(
                          "En cours",
                          controller.reclamationList
                              .where((r) =>
                                  r.status.toLowerCase() == 'in progress')
                              .length
                              .toString(),
                          Colors.blue,
                        ),
                        _buildCountBadge(
                          "Resolu",
                          controller.reclamationList
                              .where((r) =>
                                  r.status.toLowerCase() == 'resolved')
                              .length
                              .toString(),
                          Colors.green,
                        ),
                      ],
                    )),
              ],
            ),
          ),

          // List of tickets
          Expanded(
            child: Obx(() {
              // Show loading spinner
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Show empty state
              if (controller.filteredList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Aucune reclamation trouvee",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Cliquez sur + pour creer un ticket",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => controller.fetchReclamations(),
                        icon: Icon(Icons.refresh),
                        label: Text("Actualiser"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show list with pull to refresh
              return RefreshIndicator(
                onRefresh: () => controller.fetchReclamations(),
                color: AppTheme.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final ticket = controller.filteredList[index];
                    return _buildTicketCard(context, ticket);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Build a small count badge for the header
  Widget _buildCountBadge(String label, String count, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Build a card for each ticket
  Widget _buildTicketCard(BuildContext context, ReclamationResponse ticket) {
    // Get status color
    Color statusColor = _getStatusColor(ticket.status);
    // Get priority color
    Color priorityColor = _getPriorityColor(ticket.priority ?? 'Medium');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => Get.to(() => ReclamationDetailScreen(reclamation: ticket)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Status and Priority badges
              Row(
                children: [
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(ticket.status),
                          size: 14,
                          color: statusColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          ticket.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  // Priority badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ticket.priority ?? 'Medium',
                      style: TextStyle(
                        color: priorityColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Spacer(),
                  // Date
                  Text(
                    ticket.createdAt != null
                        ? DateFormat('dd MMM').format(ticket.createdAt!)
                        : '',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Title
              Text(
                ticket.titre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 6),

              // Description preview
              Text(
                ticket.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 12),

              // Bottom row: Category and Actions
              Row(
                children: [
                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.label_outline,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          ticket.categorie,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rating stars if available
                  if (ticket.rating != null) ...[
                    SizedBox(width: 8),
                    Row(
                      children: List.generate(
                        ticket.rating!,
                        (i) => Icon(Icons.star, size: 14, color: Colors.amber),
                      ),
                    ),
                  ],

                  Spacer(),

                  // Action buttons
                  Row(
                    children: [
                      // Edit status button
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 20),
                        color: Colors.blue,
                        onPressed: () => _showUpdateDialog(context, ticket),
                        tooltip: 'Modifier statut',
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(8),
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20),
                        color: Colors.red,
                        onPressed: () => _confirmDelete(context, ticket.id!),
                        tooltip: 'Supprimer',
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get color based on status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  // Get icon based on status
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Icons.fiber_new;
      case 'in progress':
        return Icons.hourglass_empty;
      case 'resolved':
        return Icons.check_circle;
      case 'closed':
        return Icons.archive;
      default:
        return Icons.help_outline;
    }
  }

  // Get color based on priority
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.deepOrange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Show delete confirmation dialog
  void _confirmDelete(BuildContext context, int id) {
    Get.defaultDialog(
      title: "Supprimer?",
      middleText: "Voulez-vous vraiment supprimer cette reclamation?",
      textConfirm: "Oui, supprimer",
      textCancel: "Annuler",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteReclamation(id);
        Get.back();
      },
    );
  }

  // Show status update dialog
  void _showUpdateDialog(
      BuildContext context, ReclamationResponse reclamation) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Changer le statut",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildStatusOption("Open", Colors.orange, reclamation),
            _buildStatusOption("In Progress", Colors.blue, reclamation),
            _buildStatusOption("Resolved", Colors.green, reclamation),
            _buildStatusOption("Closed", Colors.grey, reclamation),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Build a status option tile
  Widget _buildStatusOption(
      String status, Color color, ReclamationResponse reclamation) {
    bool isSelected =
        reclamation.status.toLowerCase() == status.toLowerCase();

    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(status),
      trailing: isSelected ? Icon(Icons.check, color: color) : null,
      onTap: () {
        Get.back();
        controller.updateStatus(reclamation.id!, status);
      },
    );
  }
}
