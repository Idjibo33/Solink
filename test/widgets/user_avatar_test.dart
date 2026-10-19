import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpAvatar(WidgetTester tester, String username) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: UserAvatar(size: 25, username: username)),
      ),
    );
  }

  testWidgets('affiche la première lettre du nom', (tester) async {
    await pumpAvatar(tester, 'Ismael');
    expect(find.text('I'), findsOneWidget);
  });

  testWidgets('nom vide : repli sans crash', (tester) async {
    await pumpAvatar(tester, '');
    expect(tester.takeException(), isNull);
    expect(find.text('?'), findsOneWidget);
  });

  testWidgets('nom long : une seule lettre, sans débordement', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await pumpAvatar(tester, 'UtilisateurAvecUnNomTrèsTrèsLong');
    expect(tester.takeException(), isNull);
  });
}
