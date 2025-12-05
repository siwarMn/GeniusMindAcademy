import 'package:codajoy/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifierProfilPage extends StatelessWidget {
  ProfileController profileController=Get.put(ProfileController());
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Profil'),
        backgroundColor: Colors.grey[200],

      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 20.0),
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: AssetImage('assets/images/logoo.png'), ),
              ),
              const SizedBox(height: 20,),
              Text(
                'Veuillez remplir le formulaire ci-dessous :',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              //nom textfield
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue), // Bordure de la boîte
                  borderRadius: BorderRadius.circular(10.0), // Coins arrondis de la boîte
                ),
                child: TextFormField(
                //  controller: ,
                  decoration: InputDecoration(
                    labelText: 'Nouveau nom',
                    border: InputBorder.none, // Supprime la bordure par défaut du champ de texte
                    prefixIcon: Icon(Icons.person), // Icône à gauche du champ de texte
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // email textfield
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue), // Bordure de la boîte
                  borderRadius: BorderRadius.circular(10.0), // Coins arrondis de la boîte
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nouveau Prenom',
                    border: InputBorder.none,
                
                    prefixIcon: Icon(Icons.person_2_outlined), 
                    
                  ),
                ),
              ),

           

               const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
profileController.updateProfile(nameController.text, emailController.text);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 25.0), // Couleur du texte du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                ),
                child: Text('Modifier Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




