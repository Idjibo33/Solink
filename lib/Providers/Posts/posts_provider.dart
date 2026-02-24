import 'package:flutter/material.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Services/Firebase/Firestore/post.dart';

class PostsProvider extends ChangeNotifier {
  final _postsServices = Post();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  final Snackbarservices _snackbarservices = Snackbarservices();
  //Tous les posts
  Stream<List<PostModel>>? get posts => _postsServices.readPosts();

  //Ajouter le poste
  Future ajouterPost({
    required PostModel newpost,
    required String userId,
  }) async {
    if (newpost.content.isEmpty) {
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _postsServices.creerPost(post: newpost, userId: userId);

      _chargement = false;
      _messsage = "Poste ajoutée avec succès";
      notifyListeners();
      _snackbarservices.showSuccess(_messsage);
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
    }
  }

  //Ajouter le commentaire
  Future addComment({
    required BuildContext context,
    required Commentaire commentaire,
    required String docId,
    required String userId,
  }) async {
    if (commentaire.content.isEmpty) {
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _postsServices.addComment(
        commentaire: commentaire,
        postId: docId,
        userId: userId,
      );
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
    }
  }

  // lire les commentaire du post
  Stream<List<Commentaire>>? readcomments({required String docId}) {
    try {
      return _postsServices.readPostComments(docId);
    } catch (e) {
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
      return null;
    }
  }

  // Lires les postes de l'utilisateur
  Stream<List<PostModel>>? getUserPosts({
    required String userId,
    required BuildContext context,
  }) {
    try {
      return _postsServices.lirePostUser(userId: userId);
    } catch (e) {
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
      return null;
    }
  }
}
