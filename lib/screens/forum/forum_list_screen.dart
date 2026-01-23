import 'package:codajoy/controllers/forum_controller.dart';
import 'package:codajoy/models/forum_model.dart';
import 'package:codajoy/screens/forum/create_question_screen.dart';
import 'package:codajoy/screens/forum/question_detail_screen.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ForumListScreen extends StatelessWidget {
  ForumListScreen({Key? key}) : super(key: key);

  final ForumController controller = Get.put(ForumController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum Communautaire"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => CreateQuestionScreen()),
        label: const Text("Poser une question"),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Rechercher des questions...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() => Row(
                  children: [
                    _buildFilterChip("Tous"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Sans réponse"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Résolu"),
                  ],
                )),
          ),

          const SizedBox(height: 16),

          // Questions list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredQuestions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forum_outlined,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        "Aucune question trouvée",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Soyez le premier à poser une question!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredQuestions.length,
                itemBuilder: (context, index) {
                  final question = controller.filteredQuestions[index];
                  return GestureDetector(
                    onTap: () => Get.to(() => QuestionDetailScreen(question: question)),
                    child: _buildQuestionCard(context, question),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = controller.selectedFilter.value == label;
    return GestureDetector(
      onTap: () => controller.changeFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, ForumQuestion question) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(
              children: [
                _buildStatItem(
                  question.votes.toString(),
                  "votes",
                  question.votes > 0 ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 20),
                _buildStatItem(
                  question.answerCount.toString(),
                  "réponses",
                  question.hasAcceptedAnswer
                      ? Colors.green
                      : (question.answerCount > 0 ? Colors.blue : Colors.grey),
                  hasAccepted: question.hasAcceptedAnswer,
                ),
                const SizedBox(width: 20),
                _buildStatItem(
                  question.views.toString(),
                  "vues",
                  Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Question title
            Text(
              question.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            // Description preview
            Text(
              question.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),

            const SizedBox(height: 12),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: question.tags
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 12),

            // Author and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      child: Text(
                        question.author[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      question.author,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatDate(question.createdAt),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color,
      {bool hasAccepted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasAccepted ? Colors.green : color.withValues(alpha: 0.3),
          width: hasAccepted ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: hasAccepted ? Colors.green.withValues(alpha: 0.1) : Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasAccepted)
                const Icon(Icons.check, size: 14, color: Colors.green),
              if (hasAccepted) const SizedBox(width: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM yyyy').format(date);
    } else if (difference.inDays > 0) {
      return "Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}";
    } else if (difference.inHours > 0) {
      return "Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}";
    } else if (difference.inMinutes > 0) {
      return "Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}";
    } else {
      return "À l'instant";
    }
  }
}
