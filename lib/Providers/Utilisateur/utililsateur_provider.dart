import 'dart:async';

import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/get_it.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/utilisateur_collection.dart';

class UtililsateurProvider extends ChangeNotifier {
  final _utilisateurServices = getIt<UtilisateurCollection>();
  String? get id => getIt<AuthService>().currentUser?.uid;
  final Snackbarservices _snackbarservices = Snackbarservices();

  Stream<UtilisateurModel> get userData {
    final userId = id;
    if (userId == null) {
      return const Stream.empty();
    }
    return _utilisateurServices.lireDocUser(userId);
  }

  bool _chargement = false;
  String _messsage = "";
  String get message => _messsage;
  bool get chargement => _chargement;
  // ajouter/modifier la bio
  Future ajouterBio({required String bio, required String userId}) async {
    if (bio.isEmpty) {
      _messsage = "AJouter une bio pour continuer";
      notifyListeners();
      _snackbarservices.showError(_messsage);
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _utilisateurServices.ajouterBio(bio: bio, userId: userId);
      _chargement = false;
      _messsage = "bio ajouté avec succès";
      notifyListeners();
      _snackbarservices.showSuccess(_messsage);
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
    }
  }

  // Charger les Utilisateurs
  Stream<List<UtilisateurModel>>? readUsers({
    required String userId,
    required BuildContext context,
  }) {
    try {
      return _utilisateurServices.users(userId);
    } catch (e) {
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
      return null;
    }
  }
}
