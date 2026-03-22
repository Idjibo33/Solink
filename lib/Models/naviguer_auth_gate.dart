import 'package:flutter/material.dart';
import 'package:so_link/auth_gate.dart';

void naviguerAuthGate(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => AuthGate()),
    (Route route) => false,
  );
}
