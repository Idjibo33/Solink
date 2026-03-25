import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/helpers/get_it.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Providers/Ai%20logic/ai_logic_provider.dart';
import 'package:so_link/Providers/Auth/auth_services_provider.dart';
import 'package:so_link/Providers/Chats/chat_provider.dart';
import 'package:so_link/Providers/Machine%20learning/language.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Remote%20config/remote_config_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Providers/Version/version_provider.dart';
import 'package:so_link/Services/Firebase/Messaging/messaging.dart';
import 'package:so_link/Views/Screens/Maintenance/maintenance_screen.dart';
import 'package:so_link/Views/Screens/Update/required_update_screen.dart';
import 'package:so_link/auth_gate.dart';
import 'package:so_link/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
  } else {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();

  await Messaging().initMessaging();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServicesProvider()),
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
        ChangeNotifierProvider(create: (context) => AiLogicProvider()),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: context.watch<RemoteConfigProvider>().getAppTheme(),
        ),
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
