import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Authentification/inscription_screen.dart';

void naviguerInscriptionScreen(BuildContext context) {
  final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
  if (isIos) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => InscriptionScreen()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InscriptionScreen()),
    );
  }
}
