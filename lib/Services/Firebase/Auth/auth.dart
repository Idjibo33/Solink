import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;
  Stream<User?> get authChangesStates => auth.authStateChanges();

  // Connecter l'utilisateur avec email et mot de passe
  Future<UserCredential> connecterUtilisateur(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Deconnecter l'utilisateur
  Future<void> deconnecterUtilisateur() {
    return auth.signOut();
  }

  // Inscrire l'utilisateur avec email et mot de passe
  Future<UserCredential> inscrireUtilisateur(String email, String password) {
    return auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
