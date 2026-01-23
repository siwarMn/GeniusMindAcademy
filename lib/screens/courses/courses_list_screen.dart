import 'package:codajoy/controllers/courses_list_controller.dart';
import 'package:codajoy/Config/api_config.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Screen that shows list of PDF courses in a nice grid
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
            onPressed: () => controller.fetchCourses(),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      // Button to add new PDF
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickAndUploadFile(),
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        // Show loading
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Chargement des cours..."),
              ],
            ),
          );
        }

        // Show empty state
        if (controller.courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 80, color: Colors.grey[300]),
                SizedBox(height: 16),
                Text(
                  "Aucun cours disponible",
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  "Cliquez sur + pour ajouter un cours",
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchCourses(),
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

        // Show courses in a grid
        return RefreshIndicator(
          onRefresh: () => controller.fetchCourses(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.courses.length,
            itemBuilder: (context, index) {
              final course = controller.courses[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () => _showCourseOptions(context, course),
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Course image area
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            // PDF icon background
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  size: 50,
                                  color: Colors.red[400],
                                ),
                              ),
                            ),
                            // Delete button
                            Positioned(
                              right: 5,
                              top: 5,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.delete, size: 16, color: Colors.red),
                                  onPressed: () => _confirmDelete(course),
                                ),
                              ),
                            ),
                            // PDF badge
                            Positioned(
                              left: 5,
                              top: 5,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "PDF",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Course info
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.fileName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Cliquez pour ouvrir",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
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
          ),
        );
      }),
    );
  }

  // Show options when tapping a course
  void _showCourseOptions(BuildContext context, course) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              course.fileName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // View PDF button
            ListTile(
              leading: Icon(Icons.visibility, color: AppTheme.primaryColor),
              title: Text("Voir le PDF"),
              onTap: () {
                Get.back();
                _openPdf(course.id);
              },
            ),
            // Download button
            ListTile(
              leading: Icon(Icons.download, color: Colors.green),
              title: Text("Telecharger"),
              onTap: () {
                Get.back();
                _downloadPdf(course.id, course.fileName);
              },
            ),
            // Delete button
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Supprimer"),
              onTap: () {
                Get.back();
                _confirmDelete(course);
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Open PDF in browser
  Future<void> _openPdf(int fileId) async {
    try {
      // Get token
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'jwt_token');

      // Build URL
      String url = '${ApiConfig.baseUrl}/File/$fileId';

      // For web, we can open directly
      // For mobile, we'll open in browser
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Erreur", "Impossible d'ouvrir le PDF");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Erreur: $e");
    }
  }

  // Download PDF
  Future<void> _downloadPdf(int fileId, String fileName) async {
    try {
      String url = '${ApiConfig.baseUrl}/File/download/$fileId';
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Get.snackbar("Telechargement", "Le telechargement va commencer...");
      } else {
        Get.snackbar("Erreur", "Impossible de telecharger");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Erreur: $e");
    }
  }

  // Confirm delete dialog
  void _confirmDelete(course) {
    Get.defaultDialog(
      title: "Confirmer",
      middleText: "Voulez-vous supprimer ce cours?",
      textConfirm: "Oui",
      textCancel: "Non",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.deleteFile(course.id);
      },
    );
  }

  // Pick and upload a PDF file
  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        String fileName = result.files.single.name;
        await controller.uploadFile(result.files.single.bytes!, fileName);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de selectionner le fichier");
    }
  }
}
