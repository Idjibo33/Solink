import 'package:flutter/material.dart';
import 'package:so_link/Models/SnackBars/error_snackbar.dart';
import 'package:so_link/Models/SnackBars/succes_snackbar.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Services/Firebase/Firestore/post.dart';

class PostsProvider extends ChangeNotifier {
  final _postsServices = Post();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  Stream<List<PostModel>>? get userPosts => _postsServices.lirePostUser();
  //Ajouter le poste
  Future ajouterPost({
    required BuildContext context,
    required PostModel newpost,
  }) async {
    if (newpost.content.isEmpty) {
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _postsServices.creerPost(post: newpost);

      _chargement = false;
      _messsage = "Poste ajoutée avec succès";
      notifyListeners();
      if (context.mounted) showSucces(context: context, message: _messsage);
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      if (context.mounted) showError(context: context, message: _messsage);
    }
  }

  //Ajouter un like au post
  Future likePost({
    required BuildContext context,
    required String postId,
  }) async {
    try {
      _postsServices.likePost(postId);
    } catch (e) {
      _messsage = e.toString();
      notifyListeners();
      if (context.mounted) showError(context: context, message: _messsage);
    }
  }
}
