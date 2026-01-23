import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'login_screen.dart';
import 'package:get/get.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            buildPage(
              imagePath: "assets/images/onboarding1.jpg",
              title: "trouver le meilleur ",
              subTitle: "cours avec nous",
              description: [
                "L'apprentissage peut être plus facile",
                "Vous pouvez profiter d'apprendre avec nous",
                "Alors… Que veux-tu vraiment apprendre ?",
              ],
              currentPage: 0,
              pageCount: 3,
              onTap: () {
                // Navigate to login screen
                Get.to(() => LoginScreen());
              },
              container: Container(
                color: Colors.blue,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Center(child: Text('Continue')),
              ),
            ),
            buildPage(
              imagePath: "assets/images/onboarding2.jpg",
              title: "trouver le meilleur ",
              subTitle: "cours avec nous",
              description: [
                "L'apprentissage peut être plus facile",
                "Vous pouvez profiter d'apprendre avec nous",
                "Alors… Que veux-tu vraiment apprendre ?",
              ],
              currentPage: 1,
              pageCount: 3,
              onTap: () {
                // Navigate to login screen
                Get.to(() => LoginScreen());
              },
              container: Container(
                color: Colors.blue,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Center(child: Text('Continue')),
              ),
            ),
            buildPage(
              imagePath: "assets/images/onboarding3.png",
              title: "trouver le meilleur ",
              subTitle: "cours avec nous",
              description: [
                "L'apprentissage peut être plus facile",
                "Vous pouvez profiter d'apprendre avec nous",
                "Alors… Que veux-tu vraiment apprendre ?",
              ],
              currentPage: 2,
              pageCount: 3,
              onTap: () {
                // Add onTap functionality for the third page
                print('Tapped on the third page');
              },
              container: Container(
                color: Colors.blue,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Center(child: Text('Continue')),
              ),
            ),
            LoginScreen(),
            // Add more pages here if needed
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required String imagePath,
    required String title,
    required String subTitle,
    required List<String> description,
    required int currentPage,
    required int pageCount,
    required VoidCallback onTap,
    Widget? container,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(imagePath),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '$title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' $subTitle',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: description.map((text) => Text(text)).toList(),
                    ),
                  ),
                ],
              ),
              container!,
              DotsIndicator(
                dotsCount: pageCount,
                position: currentPage,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeColor: Colors.blue,
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
