/// Identite d'un utilisateur authentifie, independante du backend.
///
/// [uid] est l'identifiant technique (Firebase UID, UUID, ...). Il est
/// utilise comme cle de document dans le stockage.
class AuthUser {
  const AuthUser({
    required this.uid,
    required this.email,
    this.emailVerified = false,
    this.displayName,
  });

  final String uid;
  final String email;
  final bool emailVerified;
  final String? displayName;
}
