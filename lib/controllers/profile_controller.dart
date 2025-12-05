import 'dart:convert';

import 'package:codajoy/controllers/login_controller.dart';
import 'package:codajoy/screens/components/profile_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  Future<void> updateProfile(String name, String email) async {
    try {
      // Assuming you have the user's token stored somewhere
      String? token = await getToken(); // Implement this method to get the token

      if (token != null) {
        String apiUrl = 'http://192.168.1.17:8080/api/v1/auth/profile';

        final response = await http.put(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': '$token',
          },
          body: jsonEncode({
            'name': name,
            'email': email,
          }),
        );

        if (response.statusCode == 200) {
        ;
          Get.snackbar("Bravo !","Profil mis à jour avec succès");
          Get.to(ProfileScreen());
        } else {
          // Handle other status codes
          print('Failed to update profile: ${response.statusCode}');
        }
      } else {
        // Handle case where token is null
        print('Token not found');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<String?> getToken() async {
    LoginController login = Get.put(LoginController());
    return login.gettoken();
  }
}
