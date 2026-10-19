import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:so_link/Models/chat.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/helpers/get_it.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Ai%20Logic/ai_services.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/chats_collection.dart';
import 'package:so_link/Services/Firebase/Firestore/post_collection.dart';
import 'package:so_link/Services/Firebase/Firestore/utilisateur_collection.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_id.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_translation.dart';

class FakeUser implements User {
  @override
  final String uid;
  FakeUser(this.uid);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthService implements AuthService {
  User? user;
  FakeAuthService({this.user});

  @override
  User? get currentUser => user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSnackbarservices implements Snackbarservices {
  final List<String> succes = [];
  final List<String> erreurs = [];

  @override
  void showSuccess(String message) => succes.add(message);

  @override
  void showError(String message) => erreurs.add(message);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePostCollection implements PostCollection {
  final StreamController<List<PostModel>> postsController =
      StreamController<List<PostModel>>.broadcast();
  final StreamController<List<Commentaire>> commentairesController =
      StreamController<List<Commentaire>>.broadcast();

  Object? erreurAddComment;
  Object? erreurAddLike;
  int appelsCreerPost = 0;

  @override
  Stream<List<PostModel>>? readPosts() => postsController.stream;

  @override
  Stream<List<Commentaire>> readPostComments(String docId) =>
      commentairesController.stream;

  @override
  Stream<List<PostModel>>? lirePostUser({required String userId}) =>
      postsController.stream;

  @override
  Future creerPost({required PostModel post, required String userId}) async {
    appelsCreerPost++;
  }

  @override
  Future addComment({
    required Commentaire commentaire,
    required String postId,
    required String userId,
  }) async {
    if (erreurAddComment != null) {
      throw erreurAddComment!;
    }
  }

  @override
  Future addLike({required String docId, required String userId}) async {
    if (erreurAddLike != null) {
      throw erreurAddLike!;
    }
  }

  @override
  Future removeLike({required String docId, required String userId}) async {}

  @override
  String get userCollection => 'users';

  void emitPosts(List<PostModel> posts) => postsController.add(posts);

  void emitErreurPosts(Object erreur) => postsController.addError(erreur);

  void emitCommentaires(List<Commentaire> commentaires) =>
      commentairesController.add(commentaires);

  void emitErreurCommentaires(Object erreur) =>
      commentairesController.addError(erreur);

  Future<void> fermer() async {
    await postsController.close();
    await commentairesController.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUtilisateurCollection implements UtilisateurCollection {
  UtilisateurModel? utilisateur;

  @override
  Stream<UtilisateurModel> lireDocUser(String id) => Stream.value(utilisateur!);

  @override
  Stream<List<UtilisateurModel>> users(String userId) =>
      Stream.value(const []);

  @override
  Future ajouterBio({required String bio, required String userId}) async {}

  @override
  Future creerDocUser({required UtilisateurModel utilisateur}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeChatsCollection implements ChatsCollection {
  final StreamController<List<Chat>> chatsController =
      StreamController<List<Chat>>.broadcast();
  int appelsSendChat = 0;

  @override
  Stream<List<Chat>> getChats({
    required String receiverId,
    required String senderId,
  }) =>
      chatsController.stream;

  @override
  Future sendChat({
    required String content,
    required String receiverId,
    required String senderId,
  }) async {
    appelsSendChat++;
  }

  void emit(List<Chat> chats) => chatsController.add(chats);

  Future<void> fermer() => chatsController.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAiServices implements AiServices {
  String? reponse;
  Object? erreur;

  @override
  Future<String?> generatePost(String description) async {
    if (erreur != null) {
      throw erreur!;
    }
    return reponse;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLanguageId implements LanguageId {
  String langue = 'fr';

  @override
  Future<String> processText(String texte) async => langue;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLanguageTranslation implements LanguageTranslation {
  @override
  Future<String> translateFrToEn(String texte) async => 'EN:$texte';

  @override
  Future<String> translateEnToFr(String texte) async => 'FR:$texte';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

UtilisateurModel utilisateurTest({
  String id = 'user-1',
  String nom = 'Ismael',
  String prenom = 'Djibo',
  int posts = 0,
  int followers = 0,
  int followings = 0,
}) {
  return UtilisateurModel(
    id: id,
    nom: nom,
    prenom: prenom,
    email: '$id@test.dev',
    nombrePosts: posts,
    followers: followers,
    followings: followings,
    creeLe: Timestamp.now(),
  );
}

PostModel postTest({
  String id = 'post-1',
  String userId = 'user-1',
  String userName = 'Ismael',
  String content = 'Contenu de test',
  List likes = const [],
  int comments = 0,
}) {
  return PostModel(
    id: id,
    userId: userId,
    userName: userName,
    content: content,
    likes: likes,
    comments: comments,
    creeLe: Timestamp.now(),
  );
}

Commentaire commentaireTest({
  String id = 'com-1',
  String userName = 'Ismael',
  String content = 'Commentaire de test',
}) {
  return Commentaire(
    id: id,
    userId: 'user-1',
    userName: userName,
    content: content,
    creeLe: Timestamp.now(),
  );
}

Chat chatTest({
  String senderId = 'user-1',
  String content = 'Message de test',
}) {
  return Chat(senderId: senderId, content: content, envoyeLe: Timestamp.now());
}

Future<void> enregistrerFakesGetIt({
  FakeAuthService? auth,
  FakePostCollection? posts,
  FakeUtilisateurCollection? utilisateurs,
  FakeChatsCollection? chats,
  FakeSnackbarservices? snackbars,
}) async {
  await getIt.reset();
  getIt.registerSingleton<AuthService>(auth ?? FakeAuthService());
  getIt.registerSingleton<Snackbarservices>(
    snackbars ?? FakeSnackbarservices(),
  );
  getIt.registerSingleton<PostCollection>(posts ?? FakePostCollection());
  getIt.registerSingleton<UtilisateurCollection>(
    utilisateurs ?? FakeUtilisateurCollection(),
  );
  getIt.registerSingleton<ChatsCollection>(chats ?? FakeChatsCollection());
}
