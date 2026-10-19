import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/Providers/Machine%20learning/language.dart';

import '../fixtures/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeLanguageId languageId;
  late FakeLanguageTranslation traduction;
  late LanguageProvider provider;

  setUp(() {
    languageId = FakeLanguageId();
    traduction = FakeLanguageTranslation();
    provider = LanguageProvider(
      languageId: languageId,
      languageTranslation: traduction,
    );
  });

  test('français : traduction vers anglais et chargement retombé', () async {
    final resultat = await provider.translateLanguage(texte: 'bonjour');
    expect(resultat, 'EN:bonjour');
    expect(provider.chargement, isFalse);
  });

  test('anglais : traduction vers français', () async {
    languageId.langue = 'en';
    final resultat = await provider.translateLanguage(texte: 'hello');
    expect(resultat, 'FR:hello');
    expect(provider.chargement, isFalse);
  });

  test('langue inconnue : message dédié et chargement retombé', () async {
    languageId.langue = 'es';
    final resultat = await provider.translateLanguage(texte: 'hola');
    expect(resultat, isNull);
    expect(provider.message, "Langue non-detecté");
    expect(provider.chargement, isFalse);
  });

  test('erreur du service : chargement retombé et message', () async {
    final providerEnErreur = LanguageProvider(
      languageId: _LanguageIdEnErreur(),
      languageTranslation: traduction,
    );
    final resultat = await providerEnErreur.translateLanguage(texte: 'bonjour');
    expect(resultat, isNull);
    expect(providerEnErreur.chargement, isFalse);
    expect(providerEnErreur.message, isNotEmpty);
  });
}

class _LanguageIdEnErreur implements FakeLanguageId {
  @override
  String langue = 'fr';

  @override
  Future<String> processText(String texte) async {
    throw StateError('service indisponible');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
