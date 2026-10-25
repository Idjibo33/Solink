import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

class UserService {
  UserService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String usersCollection = 'users';
  static const String privateUsersCollection = 'users_private';

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(usersCollection);

  Future<void> createUserProfile({
    required String id,
    required String nom,
    required String prenom,
    required String email,
  }) async {
    final batch = _firestore.batch();
    batch.set(_users.doc(id), {
      'id': id,
      'nom': nom.trim(),
      'prenom': prenom.trim(),
      'bio': '',
      'posts': 0,
      'followers': 0,
      'followings': 0,
      'creeLe': FieldValue.serverTimestamp(),
    });
    batch.set(_firestore.collection(privateUsersCollection).doc(id), {
      'id': id,
      'email': email.trim().toLowerCase(),
      'creeLe': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  Future<UserModel?> getUser(String id) async {
    final snapshot = await _users.doc(id).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    return UserModel.fromJson({...data, 'id': id});
  }

  Stream<UserModel> watchUser(String id) {
    return _users.doc(id).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        throw StateError('Profil utilisateur introuvable.');
      }
      return UserModel.fromJson({...data, 'id': doc.id});
    });
  }

  Stream<List<UserModel>> watchOtherUsers(String currentUserId) {
    return _users
        .where('id', isNotEqualTo: currentUserId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  Future<void> updateBio({required String userId, required String bio}) {
    return _users.doc(userId).update({'bio': bio.trim()});
  }

  /// Migre l'e-mail historique de `users/{uid}` vers `users_private/{uid}`.
  ///
  /// Les comptes créés avant la séparation des données publiques/privées
  /// peuvent encore exposer leur e-mail dans le profil public. Cette migration
  /// idempotente s'exécute à la connexion et supprime le champ du document
  /// public. Le script admin `tool/migrate_user_emails.mjs` couvre les comptes
  /// qui ne se reconnectent pas.
  Future<void> migrateLegacyEmail({
    required String userId,
    String? fallbackEmail,
  }) async {
    final userRef = _users.doc(userId);
    final privateRef = _firestore
        .collection(privateUsersCollection)
        .doc(userId);

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      final publicData = userSnapshot.data();
      if (!userSnapshot.exists ||
          publicData == null ||
          !publicData.containsKey('email')) {
        return;
      }

      final legacyEmail = (publicData['email'] as String?)
          ?.trim()
          .toLowerCase();
      final currentEmail = fallbackEmail?.trim().toLowerCase();
      final email = (currentEmail != null && currentEmail.isNotEmpty)
          ? currentEmail
          : legacyEmail;
      if (email == null || email.isEmpty) {
        return;
      }

      final creeLe = publicData['creeLe'];
      final posts = publicData['posts'];
      final followers = publicData['followers'];
      final followings = publicData['followings'];
      if (creeLe == null ||
          posts == null ||
          followers == null ||
          followings == null) {
        // Profil trop ancien pour être migré côté client : le script admin,
        // qui contourne les règles, reste nécessaire.
        return;
      }

      final privateSnapshot = await transaction.get(privateRef);
      if (!privateSnapshot.exists) {
        transaction.set(privateRef, {
          'id': userId,
          'email': email,
          'creeLe': FieldValue.serverTimestamp(),
        });
      }

      transaction.set(userRef, {
        'id': publicData['id'] ?? userId,
        'nom': publicData['nom'] ?? '',
        'prenom': publicData['prenom'] ?? '',
        'bio': publicData['bio'] ?? '',
        'posts': posts,
        'followers': followers,
        'followings': followings,
        'creeLe': creeLe,
      });
    });
  }
}
