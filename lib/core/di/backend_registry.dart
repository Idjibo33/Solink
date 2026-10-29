import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:so_link/features/auth/data/firestore/firestore_user_store.dart';
import 'package:so_link/features/auth/data/gateways/firebase_auth_gateway.dart';
import 'package:so_link/features/auth/domain/repositories/auth_gateway.dart';
import 'package:so_link/features/auth/domain/repositories/user_store.dart';
import 'package:so_link/features/chats/data/firestore/firestore_chat_store.dart';
import 'package:so_link/features/chats/domain/repositories/chat_store.dart';
import 'package:so_link/features/posts/data/firestore/firestore_post_store.dart';
import 'package:so_link/features/posts/domain/repositories/post_store.dart';

/// Backends de stockage supportes par l'application.
enum Backend {
  /// Firebase Firestore (stockage) et Firebase Auth (identite).
  firebase,

  /// Adaptateurs a implementer pour un autre fournisseur.
  /// @see BackendRegistry
  custom,
}

/// Selection du backend au moment du build.
///
/// Le backend est choisi par `--dart-define=BACKEND=firebase`. Ce point est le
/// seul endroit de l'application ou l'on choisit une implementation : tout
/// le reste du code ne connait que les ports (interfaces) du domaine.
///
/// Pour brancher un nouveau backend :
///  1. ecrire les adaptateurs dans `lib/features/<feature>/data/<backend>/`,
///  2. les enregistrer dans [BackendRegistry],
///  3. ajouter une valeur a [Backend].
enum BackendSelection {
  firebase('firebase'),
  custom('custom');

  const BackendSelection(this.key);

  final String key;

  static BackendSelection fromEnvironment() {
    const key = String.fromEnvironment('BACKEND', defaultValue: 'firebase');
    return BackendSelection.values.firstWhere(
      (selection) => selection.key == key,
      orElse: () => BackendSelection.firebase,
    );
  }
}

/// Adaptateurs de backend regroupes par fournisseur.
class BackendAdapters {
  const BackendAdapters({
    required this.authGateway,
    required this.userStore,
    required this.postStore,
    required this.chatStore,
  });

  final AuthGateway authGateway;
  final UserStore userStore;
  final PostStore postStore;
  final ChatStore chatStore;
}

/// Registre des adaptateurs disponibles.
///
/// Chaque entree associe un backend a ses adaptateurs. Pour ajouter un
/// fournisseur, il suffit d'ajouter une entree ici et un dossier
/// `data/<backend>/` dans chaque feature concernee.
abstract final class BackendRegistry {
  static BackendAdapters resolve(BackendSelection selection) {
    return switch (selection) {
      BackendSelection.firebase => _firebase(),
      BackendSelection.custom => _firebase(),
    };
  }

  static BackendAdapters _firebase() {
    final firestore = FirebaseFirestore.instance;
    return BackendAdapters(
      authGateway: FirebaseAuthGateway(FirebaseAuth.instance),
      userStore: FirestoreUserStore(firestore),
      postStore: FirestorePostStore(firestore),
      chatStore: FirestoreChatStore(firestore),
    );
  }
}
