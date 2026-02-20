import 'package:flutter/material.dart';
import 'package:so_link/Models/SnackBars/error_snackbar.dart';
import 'package:so_link/Models/SnackBars/succes_snackbar.dart';
import 'package:so_link/Models/naviguer_auth_gate.dart';
import 'package:so_link/Services/Firebase/Auth/deconnexion.dart';

class DeconnexionProvider extends ChangeNotifier {
  final _deconnexionService = Deconnexion();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  // Deconnecter l'utilisateur
  Future deconnecterUtilisateur(BuildContext context) async {
    _chargement = true;
    notifyListeners();
    try {
      await _deconnexionService.deconnecterUtilisateur();
      _chargement = false;
      _messsage = "Déconnecter avec succès";
      notifyListeners();
      if (context.mounted) {
        showSucces(context: context, message: _messsage);
        naviguerAuthGate(context);
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
