import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:codajoy/models/reclamation_model.dart';
import 'package:codajoy/screens/reclamation/widgets/rating_dialog.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReclamationDetailScreen extends StatelessWidget {
  final ReclamationResponse reclamation;
  final ReclamationController controller = Get.find();
  final TextEditingController commentController = TextEditingController();

  ReclamationDetailScreen({Key? key, required this.reclamation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details du Ticket"),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.primaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        // Find the updated reclamation from the controller
        var updatedReclamation = controller.reclamationList.firstWhere(
          (r) => r.id == reclamation.id,
          orElse: () => reclamation,
        );

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatusChip(updatedReclamation.status),
                                Text(
                                  updatedReclamation.createdAt != null
                                      ? DateFormat('dd MMM yyyy, HH:mm')
                                          .format(updatedReclamation.createdAt!)
                                      : '',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              updatedReclamation.titre,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              updatedReclamation.description,
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Catégorie: ${updatedReclamation.categorie}",
                                    style: TextStyle(color: Colors.grey[600])),
                                TextButton.icon(
                                  onPressed: () => _showUpdateDialog(context, updatedReclamation),
                                  icon: Icon(Icons.edit, size: 16),
                                  label: Text("Changer Statut"),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Priorité: ${updatedReclamation.priority ?? 'N/A'}",
                                    style: TextStyle(color: Colors.grey[600])),
                                if (updatedReclamation.status.toLowerCase() == 'resolved' &&
                                    updatedReclamation.rating == null)
                                  TextButton.icon(
                                    onPressed: () => Get.dialog(RatingDialog(reclamationId: updatedReclamation.id!)),
                                    icon: Icon(Icons.star, size: 16),
                                    label: Text("Rate"),
                                  ),
                                if (updatedReclamation.rating != null)
                                  Row(
                                    children: List.generate(
                                      updatedReclamation.rating!,
                                      (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      "Commentaires",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),

                    // Comments List
                    if (updatedReclamation.comments.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Aucun commentaire pour le moment.",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: updatedReclamation.comments.length,
                        separatorBuilder: (c, i) => SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final comment = updatedReclamation.comments[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(comment.author,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor)),
                                    Text(
                                        DateFormat('dd MMM HH:mm')
                                            .format(comment.date),
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(comment.text),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Add Comment Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5))
              ]),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          hintText: "Écrire un commentaire...",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () {
                        if (commentController.text.trim().isNotEmpty) {
                          controller.addComment(
                              updatedReclamation.id!, commentController.text.trim());
                          commentController.clear();
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'open':
        color = Colors.orange;
        break;
      case 'in progress':
        color = Colors.blue;
        break;
      case 'resolved':
        color = Colors.green;
        break;
      case 'closed':
        color = Colors.grey;
        break;
      default:
        color = Colors.blueGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, ReclamationResponse rec) {
    Get.defaultDialog(
      title: "Mettre à jour le statut",
      content: Column(
        children: [
          _statusOption("Open", (val) {
            Get.back();
            controller.updateStatus(rec.id!, val);
          }),
          _statusOption("In Progress", (val) {
            Get.back();
            controller.updateStatus(rec.id!, val);
          }),
          _statusOption("Resolved", (val) {
            Get.back();
            controller.updateStatus(rec.id!, val);
          }),
          _statusOption("Closed", (val) {
            Get.back();
            controller.updateStatus(rec.id!, val);
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
