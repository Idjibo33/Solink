import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/Models/helpers/forms_validation.dart';
import 'package:so_link/Models/helpers/get_it.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';

import '../fixtures/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeSnackbarservices snackbars;
  late FormsValidation form;

  setUp(() async {
    snackbars = FakeSnackbarservices();
    await getIt.reset();
    getIt.registerSingleton<Snackbarservices>(snackbars);
    form = FormsValidation();
  });

  test('inscription : champs vides refusés avec message', () {
    expect(form.validateUserInscriptionForm('', '', '', ''), isFalse);
    expect(snackbars.erreurs, contains("Toutes les cases sont obligatoires"));
  });

  test('inscription : champs remplis acceptés', () {
    expect(form.validateUserInscriptionForm('a', 'b', 'c@d.e', '123456'), isTrue);
    expect(snackbars.erreurs, isEmpty);
  });

  test('connexion : mot de passe trop court refusé', () {
    expect(form.validateUserConnexionForm('a@b.c', '123'), isFalse);
    expect(
      snackbars.erreurs,
      contains("Le mot de passe doit avoir plus de 6 caractères"),
    );
  });

  test('connexion : formulaire valide accepté', () {
    expect(form.validateUserConnexionForm('a@b.c', '123456'), isTrue);
  });
}
