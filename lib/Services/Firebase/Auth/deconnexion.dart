import 'package:firebase_auth/firebase_auth.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';

class Deconnexion {
  final auth = AuthService();
  // Deconnecter l'utilisateur
  Future deconnecterUtilisateur() {
    try {
      return auth.authService.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }
}
