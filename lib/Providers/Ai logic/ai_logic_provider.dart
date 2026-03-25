import 'package:flutter/material.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Services/Firebase/Ai%20Logic/ai_services.dart';

class AiLogicProvider extends ChangeNotifier {
  final AiServices _aiServices = AiServices();
  final Snackbarservices _snackbarservices = Snackbarservices();
  bool _chargement = false;
  bool get chargement => _chargement;
  String _messageErreur = "";
  String get messageErreur => _messageErreur;

  Future<String?> generatePostTexte({required String prompt}) async {
    try {
      _chargement = true;
      notifyListeners();
      final generation = await _aiServices.generatePost(prompt);
      _chargement = false;
      notifyListeners();
      return generation;
    } on Exception catch (e) {
      _chargement = false;
      _messageErreur = e.toString();
      notifyListeners();
      _snackbarservices.showError(_messageErreur);
      return null;
    }
  }
}
