import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:codajoy/models/reclamation_model.dart';
import 'package:codajoy/screens/reclamation/create_reclamation_screen.dart';
import 'package:codajoy/screens/reclamation/reclamation_detail_screen.dart';
import 'package:codajoy/screens/reclamation/widgets/filter_bottom_sheet.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReclamationListScreen extends StatelessWidget {
  ReclamationListScreen({Key? key}) : super(key: key);

  final ReclamationController controller = Get.put(ReclamationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réclamations"),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Get.bottomSheet(FilterBottomSheet());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => CreateReclamationScreen()),
        label: const Text("Nouveau Ticket"),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Rechercher...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        "Aucune réclamation trouvée",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredList.length,
                itemBuilder: (context, index) {
                  final ticket = controller.filteredList[index];
                  return GestureDetector(
                    onTap: () => Get.to(
                        () => ReclamationDetailScreen(reclamation: ticket)),
                    child: _buildTicketCard(context, ticket),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, ReclamationResponse ticket) {
    Color statusColor;
    switch (ticket.status.toLowerCase()) {
      case 'resolved':
        statusColor = Colors.green;
        break;
      case 'in progress':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket.status,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                Text(
                  ticket.createdAt != null
                      ? DateFormat('dd MMM yyyy').format(ticket.createdAt!)
                      : '',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ticket.titre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.label_outline,
                        size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      ticket.categorie,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                      onPressed: () => _showUpdateDialog(context, ticket),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _confirmDelete(context, ticket.id!),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    Get.defaultDialog(
        title: "Supprimer?",
        middleText: "Voulez-vous vraiment supprimer cette réclamation?",
        textConfirm: "Oui",
        textCancel: "Non",
        confirmTextColor: Colors.white,
        onConfirm: () {
          controller.deleteReclamation(id);
          Get.back();
        });
  }

  void _showUpdateDialog(BuildContext context, ReclamationResponse reclamation) {
    Get.defaultDialog(
      title: "Mettre à jour le statut",
      content: Column(
        children: [
          _statusOption("Open", (val) {
            Get.back();
            controller.updateStatus(reclamation.id!, val);
          }),
          _statusOption("In Progress", (val) {
            Get.back();
            controller.updateStatus(reclamation.id!, val);
          }),
          _statusOption("Resolved", (val) {
            Get.back();
            controller.updateStatus(reclamation.id!, val);
          }),
          _statusOption("Closed", (val) {
            Get.back();
            controller.updateStatus(reclamation.id!, val);
          }),
        ],
      ),
    );
  }

  Widget _statusOption(String label, Function(String) onTap) {
    return ListTile(
      title: Text(label),
      onTap: () => onTap(label),
    );
  }
}
