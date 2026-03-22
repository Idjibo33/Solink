import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Authentification/on_boarding_screen.dart';

void naviguerOnboardingScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OnBoardingScreen()),
  );
}
