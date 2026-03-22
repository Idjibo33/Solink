import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Profil/profil_screen.dart';

void naviguerProfilScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilScreen()),
  );
}
