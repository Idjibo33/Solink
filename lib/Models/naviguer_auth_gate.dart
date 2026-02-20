import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/auth_gate.dart';

void naviguerAuthGate(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => AuthGate()),
    );
  }
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => AuthGate()),
  );
}
