import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Authentification/on_boarding_screen.dart';

void naviguerOnboardingScreen(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => OnBoardingScreen()),
    );
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OnBoardingScreen()),
  );
}
