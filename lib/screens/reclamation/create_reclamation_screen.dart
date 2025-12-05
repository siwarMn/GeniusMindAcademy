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
  final RxString selectedCategory = 'Technique'.obs;

  final List<String> categories = [
    'Technique',
    'Compte',
    'Facturation',
    'Autre'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Ticket"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
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
                                    selectedCategory.value);
                                if (success) {
                                  Get.back();
                                  Get.snackbar("Envoyé",
                                      "Votre ticket a été créé avec succès");
                                } else {
                                  Get.snackbar(
                                      "Erreur", "Une erreur est survenue");
                                }
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
