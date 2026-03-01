import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_id.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_translation.dart';

class LanguageProvider extends ChangeNotifier {
  final LanguageId _languageId = LanguageId();
  final LanguageTranslation _languageTranslation = LanguageTranslation();
  bool _chargement = false;
  String _messsage = "";
  bool get chargement => _chargement;
  final Snackbarservices _snackbarservices = Snackbarservices();

  //Traiter un texte
  Future<String?> translateLanguage({required String texte}) async {
    try {
      _chargement = true;
      notifyListeners();
      final reponse = await _languageId.processText(texte);
      if (reponse == "fr") {
        return await _languageTranslation.translateFrToEn(texte);
      }
      if (reponse == "en") {
        return await _languageTranslation.translateEnToFr(texte);
      } else {
        _chargement = false;
        _messsage = "Langue non-detecté";
        notifyListeners();
        _snackbarservices.showError(_messsage);
        return null;
      }
    } catch (e) {
      _messsage = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messsage);
      return null;
    }
  }
}
