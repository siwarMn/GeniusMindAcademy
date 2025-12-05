import 'dart:math';
import 'package:codajoy/controllers/courses_list_controller.dart';
import 'package:codajoy/models/course_model.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCourseScreen extends StatelessWidget {
  final CoursesListController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController imageController =
      TextEditingController(text: "assets/images/cb.png"); // Default
  final TextEditingController pdfController =
      TextEditingController(text: "assets/pdfs/python.pdf"); // Default

  CreateCourseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Cours"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(titleController, "Titre du cours"),
            _buildTextField(descController, "Description", maxLines: 3),
            _buildTextField(imageController, "Chemin de l'image (asset)"),
            _buildTextField(pdfController, "Chemin du PDF (asset/url)"),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    controller.addCourse(Course(
                      id: Random().nextInt(1000).toString(),
                      title: titleController.text,
                      description: descController.text,
                      imageAsset: imageController.text,
                      pdfUrl: pdfController.text,
                    ));
                    Get.back();
                    Get.snackbar("Succès", "Cours ajouté avec succès",
                        backgroundColor: Colors.green.withOpacity(0.1));
                  } else {
                    Get.snackbar(
                        "Erreur", "Veuillez remplir les champs obligatoires");
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text("Ajouter", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
