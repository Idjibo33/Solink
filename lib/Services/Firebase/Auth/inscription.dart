import 'package:firebase_auth/firebase_auth.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';

class Inscription {
  final auth = AuthService();
  // Inscrire l'utilisateur avec email et mot de passe
  Future<UserCredential> inscrireUtilisateur(String email, String password) {
    try {
      return auth.authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }
}
