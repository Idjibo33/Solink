import 'package:so_link/features/auth/domain/entities/auth_user.dart';

/// Port d'authentification.
///
/// Chaque fournisseur (Firebase Auth, Supabase Auth, API maison, ...) fournit
/// une implementation de cette interface. L'application ne connait que ce
/// contrat, jamais le SDK du fournisseur.
abstract interface class AuthGateway {
  /// Identite de l'utilisateur connecte, ou `null` si aucun.
  AuthUser? get currentUser;

  /// Emet a chaque changement de session (connexion, deconnexion, expiration).
  Stream<AuthUser?> authStateChanges();

  /// Inscrit un compte et retourne l'identite creee.
  Future<AuthUser> signUp({required String email, required String password});

  /// Connecte un compte existant.
  Future<AuthUser> signIn({required String email, required String password});

  /// Deconnecte la session courante.
  Future<void> signOut();
}
