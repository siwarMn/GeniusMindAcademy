import 'package:codajoy/services/user_service.dart';

import 'package:codajoy/controllers/login_controller.dart';
import 'package:codajoy/screens/components/profile_screen.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  UserService userService = MockUserService();

  Future<void> updateProfile(String name, String email) async {
    try {
      bool success = await userService.updateProfile(name, email);
      if (success) {
        Get.snackbar("Bravo !", "Profil mis à jour avec succès");
        Get.to(ProfileScreen());
      } else {
        Get.snackbar("Erreur", "Echec de la mise à jour");
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<String?> getToken() async {
    LoginController login = Get.put(LoginController());
    return login.gettoken();
  }
}
