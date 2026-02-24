import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Auth/inscription.dart';
import 'package:so_link/Services/Firebase/Firestore/creation_utilisateur.dart';

class InscriptionProvider extends ChangeNotifier {
  final _inscriptionService = Inscription();
  final _docUser = CreationUtilisateur();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  final Snackbarservices _snackbarservices = Snackbarservices();
  // Connecter l'utilisateur
  Future inscrireUtilisateur({
    required String nom,
    required String prenom,
    required String email,
    required String pw,
  }) async {
    if (email.isEmpty || pw.isEmpty || nom.isEmpty || prenom.isEmpty) {
      _messsage = "Toutes les cases sont obligatoires";
      notifyListeners();
      _snackbarservices.showError(_messsage);
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _inscriptionService.inscrireUtilisateur(email.trim(), pw.trim());
      final userId = AuthService().currentUser?.uid;
      await _docUser.creerDocUser(
        utilisateur: UtilisateurModel(
          bio: "",
          followers: 0,
          followings: 0,
          nombrePosts: 0,
          id: userId!,
          nom: nom.trim(),
          prenom: prenom.trim(),
          email: email.trim(),
          creeLe: Timestamp.now(),
        ),
      );
      _chargement = false;
      _messsage = "Compte crée avec succès";
      notifyListeners();
      _snackbarservices.showSuccess(_messsage);
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
    }
  }
}
