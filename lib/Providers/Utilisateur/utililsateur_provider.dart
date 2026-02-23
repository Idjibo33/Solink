import 'package:flutter/material.dart';
import 'package:so_link/Models/SnackBars/error_snackbar.dart';
import 'package:so_link/Models/SnackBars/succes_snackbar.dart';
import 'package:so_link/Models/naviguer_auth_gate.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/creation_utilisateur.dart';

class UtililsateurProvider extends ChangeNotifier {
  final _utilisateurServices = CreationUtilisateur();
  CreationUtilisateur get utilisateurServices => CreationUtilisateur();
  Stream<List<UtilisateurModel>>? get users => _utilisateurServices.users();

  String? get docId => AuthService().currentUser?.uid;

  Stream<UtilisateurModel> get userData =>
      _utilisateurServices.lireDocUser(docId!);
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  // ajouter/modifier la bio
  Future ajouterBio({
    required BuildContext context,
    required String bio,
  }) async {
    if (bio.isEmpty) {
      _messsage = "AJouter une bio pour continuer";
      notifyListeners();
      showError(context: context, message: _messsage);
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _utilisateurServices.ajouterBio(bio: bio);
      _chargement = false;
      _messsage = "bio ajouté avec succès";
      notifyListeners();
      if (context.mounted) {
        showSucces(context: context, message: _messsage);
        naviguerAuthGate(context);
      }
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      if (context.mounted) showError(context: context, message: _messsage);
    }
  }
}
