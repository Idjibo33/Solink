import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:so_link/Views/Screens/Commentaires/commentaire_user_infos.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('nom long tronqué, sans débordement à 320 px', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommentaireUserInfos(
            commentaire: commentaireTest(
              userName: 'UnNomUtilisateurVraimentTrèsLong',
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final texte = tester.widget<Text>(
      find.text('UnNomUtilisateurVraimentTrèsLong'),
    );
    expect(texte.maxLines, 1);
    expect(texte.overflow, TextOverflow.ellipsis);
  });
}
