import 'dart:typed_data';
import 'package:codajoy/controllers/courses_list_controller.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:codajoy/services/courses_service.dart';
import 'package:codajoy/services/download_service.dart';
import 'package:codajoy/screens/courses/pdf_viewer_screen.dart';
import 'package:codajoy/services/pdf_helper.dart' as pdf_helper;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

// Screen that shows list of PDF courses in a nice grid
class CoursesListScreen extends StatelessWidget {
  final CoursesListController controller = Get.put(CoursesListController());

  CoursesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cours Disponibles"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchCourses(),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      // Button to add new PDF
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickAndUploadFile(),
        child: const Icon(Icons.add),
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
                Icon(Icons.menu_book, size: 80, color: AppTheme.textHint),
                const SizedBox(height: 16),
                Text(
                  "Aucun cours disponible",
                  style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  "Cliquez sur + pour ajouter un cours",
                  style: TextStyle(fontSize: 14, color: AppTheme.textHint),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchCourses(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Actualiser"),
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
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  size: 50,
                                  color: AppTheme.errorColor,
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
                                  icon: Icon(Icons.delete, size: 16, color: AppTheme.errorColor),
                                  onPressed: () => _confirmDelete(course),
                                ),
                              ),
                            ),
                            // PDF badge
                            Positioned(
                              left: 5,
                              top: 5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
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
                                  color: AppTheme.textHint,
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
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              course.fileName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // View PDF button
            ListTile(
              leading: Icon(Icons.visibility, color: AppTheme.primaryColor),
              title: const Text("Voir le PDF"),
              onTap: () {
                Get.back();
                _openPdf(course.id, course.fileName);
              },
            ),
            // Download button
            ListTile(
              leading: Icon(Icons.download, color: AppTheme.successColor),
              title: const Text("Telecharger"),
              onTap: () {
                Get.back();
                _downloadPdf(course.id, course.fileName);
              },
            ),
            // Delete button
            ListTile(
              leading: Icon(Icons.delete, color: AppTheme.errorColor),
              title: const Text("Supprimer"),
              onTap: () {
                Get.back();
                _confirmDelete(course);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Open PDF - works on both web and mobile
  Future<void> _openPdf(int fileId, String fileName) async {
    if (kIsWeb) {
      // Web: fetch bytes and open in browser
      await _openPdfWeb(fileId, fileName);
    } else {
      // Mobile: navigate to PDF viewer screen
      Get.to(() => PdfViewerScreen(
        fileId: fileId,
        title: fileName,
      ));
    }
  }

  // Web-specific PDF opening
  Future<void> _openPdfWeb(int fileId, String fileName) async {
    try {
      Get.snackbar("Chargement", "Ouverture du PDF...",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));

      final service = CoursesService();
      Uint8List? bytes = await service.getPdfFile(fileId);

      if (bytes != null && bytes.isNotEmpty) {
        pdf_helper.openPdfInBrowser(bytes, fileName);
      } else {
        Get.snackbar("Erreur", "Impossible de charger le PDF",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Erreur: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Download PDF - works on both web and mobile
  Future<void> _downloadPdf(int fileId, String fileName) async {
    if (kIsWeb) {
      // Web: fetch bytes and trigger browser download
      await _downloadPdfWeb(fileId, fileName);
    } else {
      // Mobile: use download service
      DownloadService().downloadPdf(fileId, fileName);
    }
  }

  // Web-specific PDF download
  Future<void> _downloadPdfWeb(int fileId, String fileName) async {
    try {
      Get.snackbar("Telechargement", "Preparation du fichier...",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));

      final service = CoursesService();
      Uint8List? bytes = await service.getPdfFile(fileId);

      if (bytes != null && bytes.isNotEmpty) {
        pdf_helper.downloadPdfInBrowser(bytes, fileName);
        Get.snackbar("Succes", "Telechargement termine!",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Erreur", "Impossible de telecharger le PDF",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Erreur", "Erreur: $e",
          snackPosition: SnackPosition.BOTTOM);
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
