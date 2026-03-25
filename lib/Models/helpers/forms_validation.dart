import 'package:so_link/Models/helpers/get_it.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';

class FormsValidation {
  final _snackBar = getIt<Snackbarservices>();
  bool validateUserInscriptionForm(
    String nom,
    String prenom,
    String email,
    String pw,
  ) {
    if (nom.isEmpty || prenom.isEmpty | email.isEmpty | pw.isEmpty) {
      _snackBar.showError("Toutes les cases sont obligatoires");
      return false;
    } else {
      return true;
    }
  }

  bool validateUserConnexionForm(String email, String pw) {
    if (email.isEmpty | pw.isEmpty) {
      _snackBar.showError("Toutes les cases sont obligatoires");
      return false;
    }
    if (pw.length < 6) {
      _snackBar.showError("Le mot de passe doit avoir plus de 6 caractères");
      return false;
    } else {
      return true;
    }
  }
}
