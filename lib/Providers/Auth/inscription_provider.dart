import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Models/SnackBars/error_snackbar.dart';
import 'package:so_link/Models/SnackBars/succes_snackbar.dart';
import 'package:so_link/Models/naviguer_on_boarding_screen.dart';
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
  // Connecter l'utilisateur
  Future inscrireUtilisateur({
    required BuildContext context,
    required String nom,
    required String prenom,
    required String email,
    required String pw,
  }) async {
    if (email.isEmpty || pw.isEmpty || nom.isEmpty || prenom.isEmpty) {
      _messsage = "Toutes les cases sont obligatoires";
      notifyListeners();
      if (context.mounted) {
        showError(context: context, message: _messsage);
      }
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
      if (context.mounted) {
        showSucces(context: context, message: _messsage);
        naviguerOnboardingScreen(context);
      }
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      if (context.mounted) {
        showError(context: context, message: _messsage);
      }
    }
  }
}
