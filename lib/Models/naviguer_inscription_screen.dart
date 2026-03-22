import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Authentification/inscription_screen.dart';

void naviguerInscriptionScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => InscriptionScreen()),
  );
}
