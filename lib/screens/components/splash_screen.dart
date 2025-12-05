import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:codajoy/screens/on_boarding.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

// ignore: camel_case_types
class Splash_Animated extends StatelessWidget {
  const Splash_Animated({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    return Stack(
      children: [
        AnimatedSplashScreen(
          splashIconSize: 400,
          backgroundColor: Colors.white,
          pageTransitionType: PageTransitionType.leftToRight,
          splashTransition: SplashTransition.fadeTransition,
          splash: const CircleAvatar(
            radius: 200,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("assets/images/logoo.png"),
          ),
          nextScreen: OnBoarding(),
          duration: 2500,
          animationDuration: const Duration(seconds: 5),
        ),
      ],
    );
  }
}
