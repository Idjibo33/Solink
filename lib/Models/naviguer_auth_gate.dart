import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/auth_gate.dart';

void naviguerAuthGate(BuildContext context) {
  if (Platform.isIOS) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => AuthGate()),
      (Route route) => false,
    );
  }
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => AuthGate()),
    (Route route) => false,
  );
}
