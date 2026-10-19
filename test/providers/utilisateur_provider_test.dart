import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';

import '../fixtures/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthService auth;
  late FakeUtilisateurCollection utilisateurs;

  setUp(() async {
    auth = FakeAuthService();
    utilisateurs = FakeUtilisateurCollection();
    await enregistrerFakesGetIt(auth: auth, utilisateurs: utilisateurs);
  });

  test('utilisateur non connecté : userData ne plante pas', () async {
    final provider = UtililsateurProvider();
    final stream = provider.userData;
    expect(stream, isNotNull);
    expect(await stream.isEmpty, isTrue);
  });

  test('utilisateur connecté : userData expose le document', () async {
    auth.user = FakeUser('user-1');
    final modele = utilisateurTest();
    utilisateurs.utilisateur = modele;
    final provider = UtililsateurProvider();
    await expectLater(provider.userData, emits(modele));
  });

  test('bio vide : message d erreur sans appel service', () async {
    final provider = UtililsateurProvider();
    await provider.ajouterBio(bio: '', userId: 'user-1');
    expect(provider.message, "AJouter une bio pour continuer");
    expect(provider.chargement, isFalse);
  });
}
