import 'package:codajoy/controllers/courses_controller.dart';
import 'package:codajoy/controllers/courses_list_controller.dart';
import 'package:codajoy/models/course_model.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;
  final CoursesListController controller = Get.find();
  final TextEditingController commentController = TextEditingController();

  CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(course.imageAsset),
                  fit: BoxFit.cover,
                  onError: (e, s) {},
                ),
              ),
              child: Container(color: Colors.black.withOpacity(0.4)), // Dimmer
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(course.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(course.description,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16)),
                          SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () => Get.to(() => PdfViewer()),
                            icon: Icon(Icons.play_circle_fill),
                            label: Text("Commencer le cours"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          SizedBox(height: 30),
                          Divider(),
                          Text("Commentaires",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Obx(() {
                            var updatedCourse = controller.courses.firstWhere(
                                (c) => c.id == course.id,
                                orElse: () => course);
                            if (updatedCourse.comments.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("Soyez le premier à commenter!",
                                    style: TextStyle(color: Colors.grey)),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: updatedCourse.comments.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final comment = updatedCourse.comments[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                      child: Text(comment.author[0]),
                                      backgroundColor: Colors.grey[200]),
                                  title: Text(comment.author,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(comment.text,
                                          style:
                                              TextStyle(color: Colors.black)),
                                      Text(
                                          DateFormat('dd MMM HH:mm')
                                              .format(comment.date),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Comment Input
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
                                hintText: "Laisser un commentaire...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          child: IconButton(
                            icon:
                                Icon(Icons.send, color: Colors.white, size: 20),
                            onPressed: () {
                              if (commentController.text.trim().isNotEmpty) {
                                controller.addComment(
                                    course.id, commentController.text.trim());
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
