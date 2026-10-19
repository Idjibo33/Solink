import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Screens/Commentaires/commentaires_screen.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late FakePostCollection collection;

  setUp(() async {
    collection = FakePostCollection();
    await enregistrerFakesGetIt(
      auth: FakeAuthService(user: FakeUser('user-1')),
      posts: collection,
    );
  });

  Future<void> pumpEcran(WidgetTester tester) {
    return tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UtililsateurProvider()),
          ChangeNotifierProvider(create: (_) => PostsProvider()),
        ],
        child: MaterialApp(
          home: CommentairesScreen(post: postTest()),
        ),
      ),
    );
  }

  testWidgets('aucun commentaire : message dédié', (tester) async {
    await pumpEcran(tester);
    collection.emitCommentaires([]);
    await tester.pump();
    expect(find.text("Aucun commentaire trouvé"), findsOneWidget);
  });

  testWidgets('erreur du flux : message d erreur affiché', (tester) async {
    await pumpEcran(tester);
    collection.emitErreurCommentaires(Exception('index manquant'));
    await tester.pump();
    expect(find.textContaining('index manquant'), findsOneWidget);
    expect(find.text("Aucun commentaire trouvé"), findsNothing);
  });

  testWidgets('commentaires présents : rendus dans la liste', (tester) async {
    await pumpEcran(tester);
    collection.emitCommentaires([commentaireTest(content: 'Super post')]);
    await tester.pump();
    expect(find.text('Super post'), findsOneWidget);
  });
}
