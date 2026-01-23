import 'package:codajoy/controllers/profile_menu_controller.dart';
import 'package:codajoy/controllers/login_controller.dart';
import 'package:codajoy/screens/components/ModifierProfile.dart';
import 'package:codajoy/theme/app_theme.dart';
import 'package:codajoy/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final ProfileMenuController controller = Get.put(ProfileMenuController());

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Profil"),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // User Header
                Obx(() => Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                controller.userImage.value.isNotEmpty
                                    ? MemoryImage(ImageUtils.decodeImage(
                                        controller.userImage.value)!)
                                    : null,
                            child: controller.userImage.value.isEmpty ||
                                    ImageUtils.decodeImage(
                                            controller.userImage.value) ==
                                        null
                                ? Icon(Icons.person, size: 30)
                                : null,
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bonjour,",
                                style: TextStyle(
                                    fontSize: 14, color: AppTheme.textSecondary),
                              ),
                              Text(
                                controller.userName.value,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      labelText: 'Recherche',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.filteredItems.isEmpty) {
                    return Center(child: Text("Aucun résultat"));
                  }
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];
                        return GestureDetector(
                          onTap: item.onTap,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(item.icon, size: 50, color: item.color),
                                SizedBox(height: 8),
                                Text(item.title, textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      });
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppTheme.surfaceColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                // Action à effectuer pour l'accueil
              },
              child: Column(
                children: [
                  Icon(Icons.home, color: AppTheme.primaryColor),
                  Text('Accueil', style: TextStyle(color: AppTheme.primaryColor)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ModifierProfilPage());
              },
              child: Column(
                children: [
                  Icon(Icons.edit, color: AppTheme.successColor),
                  Text('Modifier Profil',
                      style: TextStyle(color: AppTheme.successColor)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showLogoutDialog(context);
              },
              child: Column(
                children: [
                  Icon(Icons.logout, color: AppTheme.errorColor),
                  Text('Deconnexion', style: TextStyle(color: AppTheme.errorColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                final LoginController login = Get.find<LoginController>();
                login.logout();
              },
            ),
          ],
        );
      },
    );
  }
}
