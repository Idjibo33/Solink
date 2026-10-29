import 'package:firebase_auth/firebase_auth.dart';
import 'package:so_link/core/errors/error_codes.dart';
import 'package:so_link/features/auth/domain/entities/auth_user.dart';
import 'package:so_link/features/auth/domain/repositories/auth_gateway.dart';

/// Adaptateur Firebase Auth du port [AuthGateway].
///
/// Les exceptions Firebase sont traduites en `AppException` pour que
/// l'application ne depende plus de ce SDK.
class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway(this._auth);

  final FirebaseAuth _auth;

  @override
  AuthUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _toAuthUser(user);
  }

  @override
  Stream<AuthUser?> authStateChanges() =>
      _auth.authStateChanges().map((user) => user == null ? null : _toAuthUser(user));

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AppException(
          ErrorCodes.unknown,
          'Création du compte impossible.',
        );
      }
      return _toAuthUser(user);
    } on FirebaseAuthException catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AppException(
          ErrorCodes.invalidCredential,
          'E-mail ou mot de passe incorrect.',
        );
      }
      return _toAuthUser(user);
    } on FirebaseAuthException catch (error) {
      throw _translate(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _translate(error);
    }
  }

  AuthUser _toAuthUser(User user) => AuthUser(
        uid: user.uid,
        email: user.email ?? '',
        emailVerified: user.emailVerified,
        displayName: user.displayName,
      );

  AppException _translate(FirebaseAuthException error) => AppException(
        error.code,
        error.message ?? 'Authentification impossible.',
        cause: error,
      );
}
