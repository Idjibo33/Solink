import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Auth/connexion_provider.dart';
import 'package:so_link/Providers/Auth/deconnexion_provider.dart';
import 'package:so_link/Providers/Auth/inscription_provider.dart';
import 'package:so_link/Providers/Chats/chat_provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/auth_gate.dart';
import 'package:so_link/constants.dart';
import 'package:so_link/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConnexionProvider()),
        ChangeNotifierProvider(create: (context) => InscriptionProvider()),
        ChangeNotifierProvider(create: (context) => DeconnexionProvider()),
        ChangeNotifierProvider(create: (context) => UtililsateurProvider()),
        ChangeNotifierProvider(create: (context) => PostsProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: couleurePrincipale),
      ),
      home: AuthGate(),
    );
  }
}
