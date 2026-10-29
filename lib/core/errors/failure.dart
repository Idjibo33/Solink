import 'package:equatable/equatable.dart';
import 'package:so_link/core/errors/error_codes.dart';

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

/// Echec du stockage de donnees, quel que soit le backend utilise.
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
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

/// Traduit une erreur technique en `Failure` affichable.
///
/// Les adaptateurs de backend lancent des `AppException` portant un code
/// stable ; ce mapping est donc independant du fournisseur utilise.
Failure mapFailure(Object error) {
  if (error is Failure) {
    return error;
  }
  if (error is AppException) {
    return _mapCode(error.code, error.message);
  }
  return UnexpectedFailure(error.toString());
}

Failure _mapCode(String code, String fallback) {
  return switch (code) {
    ErrorCodes.invalidEmail => const AuthFailure('Adresse e-mail invalide.'),
    ErrorCodes.userDisabled =>
      const AuthFailure('Ce compte est désactivé.'),
    ErrorCodes.userNotFound =>
      const AuthFailure('Aucun compte ne correspond à cet e-mail.'),
    ErrorCodes.wrongPassword => const AuthFailure('Mot de passe incorrect.'),
    ErrorCodes.invalidCredential =>
      const AuthFailure('E-mail ou mot de passe incorrect.'),
    ErrorCodes.emailAlreadyInUse =>
      const AuthFailure('Un compte existe déjà avec cet e-mail.'),
    ErrorCodes.weakPassword =>
      const AuthFailure('Le mot de passe est trop faible.'),
    ErrorCodes.networkRequestFailed =>
      const AuthFailure('Connexion réseau indisponible.'),
    ErrorCodes.tooManyRequests =>
      const AuthFailure('Trop de tentatives. Réessayez plus tard.'),
    ErrorCodes.operationNotAllowed =>
      const AuthFailure('Cette méthode de connexion est désactivée.'),
    ErrorCodes.permissionDenied =>
      const StorageFailure('Accès refusé par le serveur.'),
    ErrorCodes.notFound => const StorageFailure('Ressource introuvable.'),
    ErrorCodes.unavailable =>
      const StorageFailure('Le service est momentanément indisponible.'),
    _ => StorageFailure(fallback),
  };
}
