import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final authService = FirebaseAuth.instance;
  User? get currentUser => authService.currentUser;
  Stream<User?> get authChangesStates => authService.authStateChanges();
}
