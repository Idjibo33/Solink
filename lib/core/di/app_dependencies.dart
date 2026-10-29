import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:so_link/core/di/backend_registry.dart';
import 'package:so_link/core/di/emulator_recaptcha.dart';
import 'package:so_link/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:so_link/features/ai/data/services/ai_service.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';
import 'package:so_link/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/chats/data/repositories/chat_repository_impl.dart';
import 'package:so_link/features/chats/domain/repositories/chat_repository.dart';
import 'package:so_link/features/notifications/data/services/notification_service.dart';
import 'package:so_link/features/posts/data/repositories/post_repository_impl.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/settings/data/repositories/app_config_repository_impl.dart';
import 'package:so_link/features/settings/data/services/remote_config_service.dart';
import 'package:so_link/features/settings/domain/repositories/app_config_repository.dart';
import 'package:so_link/features/translation/data/repositories/translation_repository_impl.dart';
import 'package:so_link/features/translation/data/services/translation_service.dart';
import 'package:so_link/features/translation/domain/repositories/translation_repository.dart';

class AppDependencies {
  const AppDependencies({
    required this.authRepository,
    required this.postRepository,
    required this.chatRepository,
    required this.appConfigRepository,
    required this.translationRepository,
    required this.aiRepository,
    required this.notificationService,
  });

  final AuthRepository authRepository;
  final PostRepository postRepository;
  final ChatRepository chatRepository;
  final AppConfigRepository appConfigRepository;
  final TranslationRepository translationRepository;
  final AiRepository aiRepository;
  final NotificationService notificationService;

  static Future<AppDependencies> create() async {
    await _connectToEmulators();

    // Point unique de selection du backend : le registre choisit les
    // adaptateurs, l'application ne voit que les ports du domaine.
    final adapters = BackendRegistry.resolve(BackendSelection.fromEnvironment());

    final authRepository = AuthRepositoryImpl(
      authGateway: adapters.authGateway,
      userStore: adapters.userStore,
    );
    final postRepository = PostRepositoryImpl(adapters.postStore);
    final chatRepository = ChatRepositoryImpl(adapters.chatStore);
    final appConfigRepository = AppConfigRepositoryImpl(
      RemoteConfigService(FirebaseRemoteConfig.instance),
    );
    final translationRepository = TranslationRepositoryImpl(
      TranslationService(),
    );
    final aiRepository = AiRepositoryImpl(AiService(FirebaseAI.googleAI()));
    final notificationService = NotificationService(FirebaseMessaging.instance);
    await notificationService.initialize();

    return AppDependencies(
      authRepository: authRepository,
      postRepository: postRepository,
      chatRepository: chatRepository,
      appConfigRepository: appConfigRepository,
      translationRepository: translationRepository,
      aiRepository: aiRepository,
      notificationService: notificationService,
    );
  }

  /// Connecte l'application aux emulateurs Firebase locaux lorsque
  /// `USE_FIREBASE_EMULATORS` vaut `true` au build.
  ///
  /// L'hote se configure avec `FIREBASE_EMULATOR_HOST` :
  ///
  ///  - `10.0.2.2` : alias de la machine hote depuis l'emulateur Android (AVD).
  ///  - `127.0.0.1` : appareil physique relie par `adb reverse tcp:9099 tcp:9099`
  ///    et `adb reverse tcp:8080 tcp:8080` (defaut).
  ///
  /// L'emulateur doit etre demarre avec `--project demo-solink`.
  static Future<void> _connectToEmulators() async {
    const useEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
    if (!useEmulators) {
      return;
    }

    const configuredHost = String.fromEnvironment('FIREBASE_EMULATOR_HOST');
    final host = configuredHost.isNotEmpty
        ? configuredHost
        : (defaultTargetPlatform == TargetPlatform.android
              ? '127.0.0.1'
              : '127.0.0.1');

    // L'emulateur n'exige aucune preuve reCAPTCHA. Sans ce verificateur, le
    // SDK Android tente de joindre le service Google avant la requete et
    // echoue en developpement, ce qui empeche toute connexion.
    RecaptchaVerifierFactoryPlatform.instance =
        EmulatorRecaptchaVerifierFactory();

    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  }
}
