import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReclamationScreen extends StatelessWidget {
  CreateReclamationScreen({Key? key}) : super(key: key);

  final ReclamationController controller = Get.find<ReclamationController>();
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final RxString selectedCategory = 'App Bug'.obs;
  final RxString selectedPriority = 'Medium'.obs;

  final List<String> categories = [
    'App Bug',
    'Course Content',
    'Payment',
    'Account',
    'Feature Request',
    'Other'
  ];

  final List<String> priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Ticket"),
        iconTheme: IconThemeData(color: AppTheme.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Dites-nous quel est le problème",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Notre équipe de support vous répondra dans les plus brefs délais.",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: selectedCategory.value,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => selectedCategory.value = val!,
                decoration: const InputDecoration(
                    labelText: "Catégorie",
                    prefixIcon: Icon(Icons.category_outlined)),
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: selectedPriority.value,
                items: priorities
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => selectedPriority.value = val!,
                decoration: const InputDecoration(
                    labelText: "Priorité",
                    prefixIcon: Icon(Icons.priority_high)),
              ),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                controller: titleController,
                validator: (val) => val!.isEmpty ? 'Requis' : null,
                decoration: const InputDecoration(
                    labelText: "Objet", prefixIcon: Icon(Icons.title)),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descController,
                validator: (val) => val!.isEmpty ? 'Requis' : null,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Description détaillée",
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80), // Align icon to top
                    child: Icon(Icons.description_outlined),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 56,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                bool success = await controller.addReclamation(
                                    titleController.text,
                                    descController.text,
                                    selectedCategory.value,
                                    selectedPriority.value);

                                if (success) {
                                  Get.back();
                                  Get.snackbar(
                                    "Succès",
                                    "Votre ticket a été créé avec succès",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                }
                                // Error message is already shown by controller
                              }
                            },
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("ENVOYER"),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
