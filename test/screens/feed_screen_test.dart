import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Machine%20learning/language.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Screens/Feed/feed_screen.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late FakePostCollection collection;
  late FakeAuthService auth;
  late FakeUtilisateurCollection utilisateurs;

  setUp(() async {
    collection = FakePostCollection();
    auth = FakeAuthService(user: FakeUser('user-1'));
    utilisateurs = FakeUtilisateurCollection();
    await enregistrerFakesGetIt(
      auth: auth,
      posts: collection,
      utilisateurs: utilisateurs,
    );
  });

  Future<void> pumpFeed(WidgetTester tester) {
    return tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UtililsateurProvider()),
          ChangeNotifierProvider(create: (_) => PostsProvider()),
          ChangeNotifierProvider(
            create: (_) => LanguageProvider(
              languageId: FakeLanguageId(),
              languageTranslation: FakeLanguageTranslation(),
            ),
          ),
        ],
        child: const MaterialApp(home: FeedScreen()),
      ),
    );
  }

  testWidgets('feed vide : message dédié', (tester) async {
    await pumpFeed(tester);
    collection.emitPosts([]);
    await tester.pump();
    expect(find.text("Aucun post trouvé"), findsOneWidget);
  });

  testWidgets('feed en erreur : message et bouton réessayer', (tester) async {
    await pumpFeed(tester);
    collection.emitErreurPosts(Exception('permission refusée'));
    await tester.pump();
    expect(find.text("Impossible de charger le feed"), findsOneWidget);
    expect(find.text("Réessayer"), findsOneWidget);

    await tester.tap(find.text("Réessayer"));
    await tester.pump();
    collection.emitPosts([postTest(content: 'Post après reprise')]);
    await tester.pump();
    expect(find.text('Post après reprise'), findsOneWidget);
  });

  testWidgets('posts présents : rendus dans la liste', (tester) async {
    await pumpFeed(tester);
    collection.emitPosts([postTest(content: 'Premier post')]);
    await tester.pump();
    expect(find.text('Premier post'), findsOneWidget);
  });
}
