import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:so_link/Views/Widgets/post_user_infos.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('nom long tronqué sur une ligne, sans débordement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PostUserInfos(
            post: postTest(userName: 'UnNomUtilisateurVraimentTrèsLong'),
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
