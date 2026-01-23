import 'package:codajoy/controllers/forum_controller.dart';
import 'package:codajoy/models/forum_model.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QuestionDetailScreen extends StatefulWidget {
  final ForumQuestion question;

  const QuestionDetailScreen({Key? key, required this.question})
      : super(key: key);

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final ForumController controller = Get.find<ForumController>();
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadQuestionById(widget.question.id);
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la question"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Obx(() {
        final question = controller.selectedQuestion.value ?? widget.question;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Section
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      question.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Stats
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          "${question.views} vues",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(question.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Voting and Description
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vote buttons
                        Column(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  controller.voteQuestion(question.id, true),
                              icon: const Icon(Icons.arrow_drop_up),
                              iconSize: 40,
                              color: Colors.grey[600],
                            ),
                            Text(
                              question.votes.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.voteQuestion(question.id, false),
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 40,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Posté par",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  AppTheme.primaryColor,
                                              child: Text(
                                                question.author[0]
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              question.author,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

              // Answers Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${question.answers.length} Réponse${question.answers.length > 1 ? 's' : ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Answers list
                    if (question.answers.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.question_answer_outlined,
                                  size: 60, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                "Aucune réponse pour le moment",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Soyez le premier à répondre!",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...question.answers.map((answer) =>
                          _buildAnswerCard(answer, question.author)),

                    const SizedBox(height: 24),

                    // Answer input section
                    const Text(
                      "Votre réponse",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: answerController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: "Écrivez votre réponse ici...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (answerController.text.trim().isNotEmpty) {
                            controller.addAnswer(
                                question.id, answerController.text);
                            answerController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Publier votre réponse",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAnswerCard(ForumAnswer answer, String questionAuthor) {
    final isAuthor = answer.author == questionAuthor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: answer.isAccepted
            ? Colors.green.withValues(alpha: 0.05)
            : Colors.white,
        border: Border.all(
          color: answer.isAccepted ? Colors.green : Colors.grey.shade300,
          width: answer.isAccepted ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vote buttons
          Column(
            children: [
              IconButton(
                onPressed: () => controller.voteAnswer(answer.id, true),
                icon: const Icon(Icons.arrow_drop_up),
                iconSize: 36,
                color: Colors.grey[600],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                answer.votes.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () => controller.voteAnswer(answer.id, false),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 36,
                color: Colors.grey[600],
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 8),
              if (answer.isAccepted)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
              if (!answer.isAccepted && isAuthor)
                IconButton(
                  onPressed: () => controller.acceptAnswer(answer.id),
                  icon: const Icon(Icons.check_circle_outline),
                  color: Colors.grey[400],
                  tooltip: "Accepter cette réponse",
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Answer content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (answer.isAccepted)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "Réponse acceptée",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                Text(
                  answer.content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                          child: Text(
                            answer.author[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          answer.author,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatDate(answer.createdAt),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
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
