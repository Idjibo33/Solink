import 'package:firebase_core/firebase_core.dart';
import 'package:so_link/firebase_options.dart';

/// Initialise l'application Firebase de maniere idempotente.
///
/// Sur Android, le plugin Gradle Google Services initialise deja l'app
/// `[DEFAULT]` de maniere native au demarrage (a partir de
/// `google-services.json`). Appeler `initializeApp` une seconde fois leve
/// alors `duplicate-app`, ce qui interromp le demarrage avant le premier
/// rendu et laisse l'ecran de demarrage natif fige.
///
/// On ignore donc cette erreur precise : elle signifie que l'initialisation
/// native a deja eu lieu, ce qui est le comportement attendu. Toute autre
/// erreur Firebase est relancee pour ne pas masquer un vrai probleme.
Future<void> initializeFirebaseApp({
  FirebaseOptions? options,
}) async {
  try {
    await Firebase.initializeApp(
      options: options ?? DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (error) {
    if (error.code != 'duplicate-app') {
      rethrow;
    }
  }
}
