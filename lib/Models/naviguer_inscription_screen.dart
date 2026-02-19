import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Authentification/inscription_screen.dart';

void naviguerInscriptionScreen(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => InscriptionScreen()),
    );
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => InscriptionScreen()),
  );
}
