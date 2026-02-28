import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Providers/Auth/connexion_provider.dart';
import 'package:so_link/Providers/Auth/deconnexion_provider.dart';
import 'package:so_link/Providers/Auth/inscription_provider.dart';
import 'package:so_link/Providers/Chats/chat_provider.dart';
import 'package:so_link/Providers/Machine%20learning/language.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Remote%20config/remote_config_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Providers/Version/version_provider.dart';
import 'package:so_link/Views/Screens/Maintenance/maintenance_screen.dart';
import 'package:so_link/Views/Screens/Update/required_update_screen.dart';
import 'package:so_link/auth_gate.dart';
import 'package:so_link/Models/constants.dart';
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
        ChangeNotifierProvider(
          create: (context) => RemoteConfigProvider()
            ..init()
            ..getMaintenanceConfig()
            ..requireUpdate(),
        ),
        ChangeNotifierProvider(create: (context) => VersionProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
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
      scaffoldMessengerKey: Snackbarservices.snackbarKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: couleurePrincipale),
      ),
      home: Consumer<RemoteConfigProvider>(
        builder: (context, value, child) {
          if (value.getMaintenanceConfig()) {
            return MaintenanceScreen();
          }
          if (value.requireUpdate()) {
            return RequiredUpdateScreen();
          }
          return AuthGate();
        },
      ),
    );
  }
}
