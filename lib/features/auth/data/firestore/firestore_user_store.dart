import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/user_store.dart';

/// Adaptateur Firestore du stockage des profils.
class FirestoreUserStore implements UserStore {
  FirestoreUserStore(this._firestore);

  final FirebaseFirestore _firestore;

  static const String usersCollection = 'users';
  static const String privateUsersCollection = 'users_private';

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(usersCollection);

  @override
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

  @override
  Future<UserModel?> getUser(String id) async {
    final snapshot = await _users.doc(id).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    return _toUser(data, id);
  }

  @override
  Stream<UserModel> watchUser(String id) {
    return _users.doc(id).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        throw StateError('Profil utilisateur introuvable.');
      }
      return _toUser(data, doc.id);
    });
  }
  @override
  Stream<List<UserModel>> watchOtherUsers(String currentUserId) {
    return _users
        .where('id', isNotEqualTo: currentUserId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _toUser(doc.data(), doc.id))
              .toList(growable: false),
        );
  }

  @override
  Future<void> updateBio({required String userId, required String bio}) {
    return _users.doc(userId).update({'bio': bio.trim()});
  }

  /// Migre l'e-mail historique de `users/{uid}` vers `users_private/{uid}`.
  ///
  /// Les comptes crees avant la separation des donnees publiques/privees
  /// peuvent encore exposer leur e-mail dans le profil public. Cette
  /// migration idempotente s'execute a la connexion et supprime le champ du
  /// document public. Le script admin `tool/migrate_user_emails.mjs` couvre
  /// les comptes qui ne se reconnectent pas.
  @override
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
        // Profil trop ancien pour etre migre cote client : le script admin,
        // qui contourne les regles, reste necessaire.
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

  UserModel _toUser(Map<String, dynamic> data, String id) => UserModel.fromJson({
        ...data,
        'id': id,
        'creeLe': _toDate(data['creeLe']),
      });

  DateTime _toDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }
}
