import 'package:codajoy/controllers/courses_list_controller.dart';
import 'package:codajoy/screens/courses/course_detail_screen.dart';
import 'package:codajoy/screens/courses/create_course_screen.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoursesListScreen extends StatelessWidget {
  final CoursesListController controller = Get.put(CoursesListController());

  CoursesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cours Disponibles"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateCourseScreen()),
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.courses.isEmpty) {
          return Center(child: Text("Aucun cours disponible"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio:
                0.70, // Adjusted aspect ratio for taller card with buttons
          ),
          itemCount: controller.courses.length,
          itemBuilder: (context, index) {
            final course = controller.courses[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: InkWell(
                onTap: () => Get.to(() => CourseDetailScreen(course: course)),
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                image: DecorationImage(
                                    image: AssetImage(course.imageAsset),
                                    fit: BoxFit.cover,
                                    onError: (e, s) {})),
                            child: course.imageAsset.isEmpty ||
                                    !course.imageAsset.startsWith('assets')
                                ? Center(
                                    child: Icon(Icons.book,
                                        size: 50, color: Colors.grey[400]))
                                : null,
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: IconButton(
                                icon: Icon(Icons.delete,
                                    size: 16, color: Colors.red),
                                onPressed: () {
                                  Get.defaultDialog(
                                      title: "Confirmer",
                                      middleText:
                                          "Voulez-vous supprimer ce cours ?",
                                      textConfirm: "Oui",
                                      textCancel: "Non",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back();
                                        controller.deleteCourse(course.id);
                                      });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
