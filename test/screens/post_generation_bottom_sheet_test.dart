import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Ai%20logic/ai_logic_provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/post_generation_bottom_sheet.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late FakeAiServices aiServices;

  setUp(() async {
    aiServices = FakeAiServices();
    await enregistrerFakesGetIt(
      auth: FakeAuthService(user: FakeUser('user-1')),
    );
  });

  Future<void> pumpFeuille(WidgetTester tester) {
    return tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UtililsateurProvider()),
          ChangeNotifierProvider(create: (_) => PostsProvider()),
          ChangeNotifierProvider(
            create: (_) => AiLogicProvider(aiServices: aiServices),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: PostGenerationBottomSheet()),
        ),
      ),
    );
  }

  testWidgets('génération vide : pas de crash, bouton publier masqué', (
    tester,
  ) async {
    aiServices.reponse = null;
    await pumpFeuille(tester);
    await tester.enterText(find.byType(TextField), 'Un sujet');
    await tester.tap(find.text("Générer post"));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text("Publiez"), findsNothing);
  });

  testWidgets('génération réussie : texte rempli, bouton publier visible', (
    tester,
  ) async {
    aiServices.reponse = 'Post généré par IA';
    await pumpFeuille(tester);
    await tester.enterText(find.byType(TextField), 'Un sujet');
    await tester.tap(find.text("Générer post"));
    await tester.pumpAndSettle();
    expect(find.text("Publiez"), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Post généré par IA',
    );
  });
}
