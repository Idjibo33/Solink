import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Services/Firebase/Auth/connexion.dart';

class ConnexionProvider extends ChangeNotifier {
  final _connexionService = Connexion();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  final Snackbarservices _snackBarServices = Snackbarservices();
  // Connecter l'utilisateur
  Future connecterUtilisateur({
    required String email,
    required String pw,
  }) async {
    if (email.isEmpty || pw.isEmpty) {
      _messsage = "Toutes les cases sont obligatoires";
      _snackBarServices.showError(_messsage);
      notifyListeners();
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _connexionService.connecterUtilisateur(email.trim(), pw.trim());
      _chargement = false;
      _messsage = "Connecté avec succès en tant que $email";
      notifyListeners();
      _snackBarServices.showSuccess(_messsage);
    } catch (e) {
      _chargement = false;
      _messsage = e.toString();
      notifyListeners();
      _snackBarServices.showError(_messsage);
    }
  }
}
