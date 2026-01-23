import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

// Screen to create a new reclamation/ticket
// User fills in the form and submits it to the backend
class CreateReclamationScreen extends StatefulWidget {
  CreateReclamationScreen({Key? key}) : super(key: key);

  @override
  State<CreateReclamationScreen> createState() =>
      _CreateReclamationScreenState();
}

class _CreateReclamationScreenState extends State<CreateReclamationScreen> {
  // Controller to manage reclamations
  final ReclamationController controller = Get.find<ReclamationController>();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final titleController = TextEditingController();
  final descController = TextEditingController();

  // Selected values for dropdowns
  String selectedCategory = 'App Bug';
  String selectedPriority = 'Medium';

  // Loading state
  bool isSubmitting = false;

  // User name from storage
  String userName = 'User';

  // Available categories
  final List<Map<String, dynamic>> categories = [
    {'name': 'App Bug', 'icon': Icons.bug_report, 'color': Colors.red},
    {'name': 'Course Content', 'icon': Icons.book, 'color': Colors.blue},
    {'name': 'Payment', 'icon': Icons.payment, 'color': Colors.green},
    {'name': 'Account', 'icon': Icons.person, 'color': Colors.purple},
    {'name': 'Feature Request', 'icon': Icons.lightbulb, 'color': Colors.orange},
    {'name': 'Other', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  // Available priorities
  final List<Map<String, dynamic>> priorities = [
    {'name': 'Low', 'color': Colors.green},
    {'name': 'Medium', 'color': Colors.orange},
    {'name': 'High', 'color': Colors.deepOrange},
    {'name': 'Critical', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Load user name from secure storage
  Future<void> _loadUserName() async {
    final storage = FlutterSecureStorage();
    String? name = await storage.read(key: 'user_name');
    if (name != null && name.isNotEmpty) {
      setState(() {
        userName = name;
      });
    }
  }

  // Submit the form
  Future<void> _submitForm() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Call controller to add reclamation
      bool success = await controller.addReclamation(
        titleController.text.trim(),
        descController.text.trim(),
        selectedCategory,
        selectedPriority,
      );

      if (success) {
        // Go back to list
        Get.back();
        // Show success message
        Get.snackbar(
          "Succes!",
          "Votre ticket a ete cree avec succes",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 3),
        );
      }
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: const Text("Nouveau Ticket"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),

      // Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Besoin d'aide?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Decrivez votre probleme et notre equipe vous aidera.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category selection
                    Text(
                      "Categorie",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categories.map((cat) {
                        bool isSelected = selectedCategory == cat['name'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = cat['name'];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cat['color'].withOpacity(0.2)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? cat['color']
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat['icon'],
                                  size: 18,
                                  color:
                                      isSelected ? cat['color'] : Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  cat['name'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? cat['color']
                                        : Colors.grey[700],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 24),

                    // Priority selection
                    Text(
                      "Priorite",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: priorities.map((pri) {
                        bool isSelected = selectedPriority == pri['name'];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPriority = pri['name'];
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? pri['color'].withOpacity(0.2)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? pri['color']
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: pri['color'],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    pri['name'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? pri['color']
                                          : Colors.grey[600],
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 24),

                    // Title field
                    Text(
                      "Objet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: titleController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Veuillez entrer un objet';
                        }
                        if (val.length < 5) {
                          return 'L\'objet doit avoir au moins 5 caracteres';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Ex: Probleme de connexion",
                        prefixIcon: Icon(Icons.title),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Description field
                    Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: descController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Veuillez entrer une description';
                        }
                        if (val.length < 20) {
                          return 'La description doit avoir au moins 20 caracteres';
                        }
                        return null;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            "Decrivez votre probleme en detail...\n\nQuand est-ce que ca s'est passe?\nQu'avez-vous essaye?",
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: isSubmitting
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text("Envoi en cours..."),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send),
                                  SizedBox(width: 8),
                                  Text(
                                    "ENVOYER LE TICKET",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Info text
                    Center(
                      child: Text(
                        "Notre equipe vous repondra dans les 24 heures.",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
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
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}
