import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Authentification/connexion_screen.dart';
import 'package:so_link/Views/Screens/Authentification/on_boarding_screen.dart';
import 'package:so_link/constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: couleurePrincipale),
      ),
      home: OnBoardingScreen(),
    );
  }
}
