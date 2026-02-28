import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_id.dart';

class LanguageProvider extends ChangeNotifier {
  final LanguageId _languageId = LanguageId();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  final Snackbarservices _snackbarservices = Snackbarservices();

  //Traiter un texte
  Future<String?> getLanguageId({required String texte}) async {
    try {
      _chargement = true;
      notifyListeners();
      final reponse = await _languageId.processText(texte);
      _chargement = false;
      return reponse;
    } catch (e) {
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
      return null;
    }
  }
}
