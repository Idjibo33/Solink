import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/creation_utilisateur.dart';

class UtililsateurProvider extends ChangeNotifier {
  final _utilisateurServices = CreationUtilisateur();
  CreationUtilisateur get utilisateurServices => CreationUtilisateur();
  String? get id => AuthService().currentUser?.uid;
  final Snackbarservices _snackbarservices = Snackbarservices();

  Stream<UtilisateurModel> get userData =>
      _utilisateurServices.lireDocUser(id!);
  bool _chargement = false;
  String _messsage = "";
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
