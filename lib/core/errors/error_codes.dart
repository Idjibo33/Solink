/// Codes d'erreur stables, independants du backend.
///
/// Les adaptateurs traduisent les erreurs de leur fournisseur vers ces
/// codes. Le reste de l'application ne connait que ces codes, ce qui permet
/// de changer de fournisseur sans toucher a l'interface utilisateur.
abstract final class ErrorCodes {
  static const String invalidEmail = 'invalid-email';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String invalidCredential = 'invalid-credential';
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String weakPassword = 'weak-password';
  static const String networkRequestFailed = 'network-request-failed';
  static const String tooManyRequests = 'too-many-requests';
  static const String operationNotAllowed = 'operation-not-allowed';
  static const String permissionDenied = 'permission-denied';
  static const String notFound = 'not-found';
  static const String unavailable = 'unavailable';
  static const String unknown = 'unknown';
}

/// Erreur portant un code stable et un message affichable.
///
/// [message] est destine a l'utilisateur final, [code] est technique et
/// permet a l'application de brancher sur un cas precis.
class AppException implements Exception {
  const AppException(this.code, this.message, {this.cause});

  final String code;
  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException($code): $message';
}
