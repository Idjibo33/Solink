import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class FirestoreFailure extends Failure {
  const FirestoreFailure(super.message);
}

final class AiFailure extends Failure {
  const AiFailure(super.message);
}

final class TranslationFailure extends Failure {
  const TranslationFailure(super.message);
}

final class VersionFailure extends Failure {
  const VersionFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

Failure mapFailure(Object error) {
  if (error is Failure) {
    return error;
  }
  if (error is FirebaseAuthException) {
    return AuthFailure(_authMessage(error));
  }
  if (error is FirebaseException) {
    return FirestoreFailure(
      error.message ?? 'Une erreur Firebase est survenue.',
    );
  }
  return UnexpectedFailure(error.toString());
}

String _authMessage(FirebaseAuthException error) {
  return switch (error.code) {
    'invalid-email' => 'Adresse e-mail invalide.',
    'user-disabled' => 'Ce compte est désactivé.',
    'user-not-found' => 'Aucun compte ne correspond à cet e-mail.',
    'wrong-password' => 'Mot de passe incorrect.',
    'invalid-credential' => 'E-mail ou mot de passe incorrect.',
    'email-already-in-use' => 'Un compte existe déjà avec cet e-mail.',
    'weak-password' => 'Le mot de passe est trop faible.',
    'network-request-failed' => 'Connexion réseau indisponible.',
    'too-many-requests' => 'Trop de tentatives. Réessayez plus tard.',
    'operation-not-allowed' => 'Cette méthode de connexion est désactivée.',
    _ => error.message ?? 'Authentification impossible.',
  };
}
