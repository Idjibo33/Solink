import 'package:flutter/material.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Views/Screens/Authentification/connexion_screen.dart';
import 'package:so_link/Views/Screens/Feed/feed_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authChangesStates,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FeedScreen();
        } else {
          return ConnexionScreen();
        }
      },
    );
  }
}
