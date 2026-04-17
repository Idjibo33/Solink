import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/forms_validation.dart';
import 'package:so_link/Models/helpers/get_it.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/utilisateur_collection.dart';

class AuthServicesProvider extends ChangeNotifier {
  final _auth = getIt<AuthService>();
  final _snackbarServices = getIt<Snackbarservices>();
  final _utilisateur = getIt<UtilisateurCollection>();
  final _form = getIt<FormsValidation>();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;

  // Connecter l'utilisateur
  Future connecterUtilisateur({
    required String email,
    required String pw,
  }) async {
    final connexion = _form.validateUserConnexionForm(email, pw);
    if (!connexion) {
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _auth.connecterUtilisateur(email.trim(), pw.trim());
      _chargement = false;
      _messsage = "Connecté avec succès en tant que $email";
      notifyListeners();
      _snackbarServices.showSuccess(_messsage);
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      _snackbarServices.showError(_messsage);
    }
  }

  // Deconnecter l'utilisateur
  Future deconnecterUtilisateur() async {
    _chargement = true;
    notifyListeners();
    try {
      await _auth.deconnecterUtilisateur();
      _chargement = false;
      _messsage = "Déconnecter avec succès";
      notifyListeners();
      _snackbarServices.showSuccess(_messsage);
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      _snackbarServices.showError(_messsage);
    }
  }

  // Connecter l'utilisateur
  Future<bool> inscrireUtilisateur({
    required String nom,
    required String prenom,
    required String email,
    required String pw,
  }) async {
    final validation = _form.validateUserInscriptionForm(
      nom,
      prenom,
      email,
      pw,
    );
    if (!validation) {
      return false;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _auth.inscrireUtilisateur(email.trim(), pw.trim());
      final userId = _auth.currentUser?.uid;
      await _utilisateur.creerDocUser(
        utilisateur: UtilisateurModel(
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

      _snackbarServices.showSuccess(_messsage);
      return true;
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      _snackbarServices.showError(_messsage);
      return false;
    }
  }
}
