import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Chats/chat_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Screens/Chats/chat_room.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late FakeChatsCollection chats;

  setUp(() async {
    chats = FakeChatsCollection();
    await enregistrerFakesGetIt(chats: chats);
  });

  Future<void> pumpChatRoom(WidgetTester tester, FakeAuthService auth) async {
    await enregistrerFakesGetIt(auth: auth, chats: chats);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UtililsateurProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
        ],
        child: MaterialApp(home: ChatRoom(user: utilisateurTest(nom: 'Ismael'))),
      ),
    );
  }

  testWidgets('utilisateur non connecté : pas de crash', (tester) async {
    await pumpChatRoom(tester, FakeAuthService());
    expect(tester.takeException(), isNull);
    expect(find.text("Utilisateur non connecté"), findsOneWidget);
  });

  testWidgets('aucun message : texte dédié', (tester) async {
    await pumpChatRoom(tester, FakeAuthService(user: FakeUser('user-1')));
    chats.emit([]);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text("Aucun message"), findsOneWidget);
  });

  testWidgets('messages présents : rendus', (tester) async {
    await pumpChatRoom(tester, FakeAuthService(user: FakeUser('user-1')));
    chats.emit([
      chatTest(content: 'Salut', senderId: 'user-1'),
      chatTest(content: 'Ça va ?', senderId: 'user-2'),
    ]);
    await tester.pump();
    expect(find.text('Salut'), findsOneWidget);
    expect(find.text('Ça va ?'), findsOneWidget);
  });
}
