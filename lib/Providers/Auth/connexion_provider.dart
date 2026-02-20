import 'package:flutter/material.dart';
import 'package:so_link/Models/SnackBars/error_snackbar.dart';
import 'package:so_link/Models/SnackBars/succes_snackbar.dart';
import 'package:so_link/Services/Firebase/Auth/connexion.dart';

class ConnexionProvider extends ChangeNotifier {
  final _connexionService = Connexion();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  // Connecter l'utilisateur
  Future connecterUtilisateur({
    required BuildContext context,
    required String email,
    required String pw,
  }) async {
    if (email.isEmpty || pw.isEmpty) {
      _messsage = "Toutes les cases sont obligatoires";
      if (context.mounted) {
        showError(context: context, message: _messsage);
      }
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
      if (context.mounted) {
        showSucces(context: context, message: _messsage);
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
