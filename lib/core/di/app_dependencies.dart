import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:so_link/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:so_link/features/ai/data/services/ai_service.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';
import 'package:so_link/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:so_link/features/auth/data/services/auth_service.dart';
import 'package:so_link/features/auth/data/services/user_service.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/chats/data/repositories/chat_repository_impl.dart';
import 'package:so_link/features/chats/data/services/chat_service.dart';
import 'package:so_link/features/chats/domain/repositories/chat_repository.dart';
import 'package:so_link/features/notifications/data/services/notification_service.dart';
import 'package:so_link/features/posts/data/repositories/post_repository_impl.dart';
import 'package:so_link/features/posts/data/services/post_service.dart';
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
    final firestore = FirebaseFirestore.instance;

    final authRepository = AuthRepositoryImpl(
      authService: AuthService(FirebaseAuth.instance),
      userService: UserService(firestore),
    );
    final postRepository = PostRepositoryImpl(PostService(firestore));
    final chatRepository = ChatRepositoryImpl(ChatService(firestore));
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
}
