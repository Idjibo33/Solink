import 'package:so_link/features/auth/data/models/user_model.dart';

/// Port de stockage des profils.
///
/// Les e-mails sont separes des profils publics : `users_private` n'est
/// lisible que par son proprietaire.
abstract interface class UserStore {
  Future<void> createUserProfile({
    required String id,
    required String nom,
    required String prenom,
    required String email,
  });

  Future<UserModel?> getUser(String id);

  Stream<UserModel> watchUser(String id);

  Stream<List<UserModel>> watchOtherUsers(String currentUserId);

  Future<void> updateBio({required String userId, required String bio});

  /// Migre un e-mail historique du profil public vers le document prive.
  ///
  /// L'operation est idempotente et ne doit jamais bloquer la connexion.
  Future<void> migrateLegacyEmail({
    required String userId,
    String? fallbackEmail,
  });
}
