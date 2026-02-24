import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Services/Firebase/Auth/deconnexion.dart';

class DeconnexionProvider extends ChangeNotifier {
  final _deconnexionService = Deconnexion();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  final Snackbarservices _snackbarservices = Snackbarservices();
  // Deconnecter l'utilisateur
  Future deconnecterUtilisateur() async {
    _chargement = true;
    notifyListeners();
    try {
      await _deconnexionService.deconnecterUtilisateur();
      _chargement = false;
      _messsage = "Déconnecter avec succès";
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
