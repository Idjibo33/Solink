import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/Providers/Ai%20logic/ai_logic_provider.dart';

import '../fixtures/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAiServices aiServices;
  late AiLogicProvider provider;

  setUp(() {
    aiServices = FakeAiServices();
    provider = AiLogicProvider(aiServices: aiServices);
  });

  test('génération réussie : texte retourné et chargement retombé', () async {
    aiServices.reponse = 'Un post généré';
    final resultat = await provider.generatePostTexte(prompt: 'sujet');
    expect(resultat, 'Un post généré');
    expect(provider.chargement, isFalse);
  });

  test('erreur service : pas de crash, message enregistré', () async {
    aiServices.erreur = Exception('quota dépassé');
    final resultat = await provider.generatePostTexte(prompt: 'sujet');
    expect(resultat, isNull);
    expect(provider.chargement, isFalse);
    expect(provider.messageErreur, isNotEmpty);
  });

  test('erreur non-Exception : également attrapée', () async {
    aiServices.erreur = StateError('état invalide');
    final resultat = await provider.generatePostTexte(prompt: 'sujet');
    expect(resultat, isNull);
    expect(provider.chargement, isFalse);
    expect(provider.messageErreur, isNotEmpty);
  });
}
