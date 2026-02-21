import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Profil/profil_screen.dart';

void naviguerProfilScreen(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ProfilScreen()),
    );
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilScreen()),
  );
}
