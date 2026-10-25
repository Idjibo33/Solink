import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/router/app_router.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/chats/domain/repositories/chat_repository.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/settings/domain/repositories/app_config_repository.dart';
import 'package:so_link/features/settings/presentation/cubit/app_config_cubit.dart';
import 'package:so_link/features/translation/domain/repositories/translation_repository.dart';

import 'fakes.dart';

class IntegrationTestApp extends StatefulWidget {
  const IntegrationTestApp({
    super.key,
    required this.authRepository,
    required this.postRepository,
    this.chatRepository,
    this.appConfigRepository,
    this.translationRepository,
    this.aiRepository,
  });

  final FakeAuthRepository authRepository;
  final FakePostRepository postRepository;
  final FakeChatRepository? chatRepository;
  final FakeAppConfigRepository? appConfigRepository;
  final FakeTranslationRepository? translationRepository;
  final FakeAiRepository? aiRepository;

  @override
  State<IntegrationTestApp> createState() => _IntegrationTestAppState();
}

class _IntegrationTestAppState extends State<IntegrationTestApp> {
  late final FakeChatRepository _chatRepository;
  late final FakeAppConfigRepository _appConfigRepository;
  late final FakeTranslationRepository _translationRepository;
  late final FakeAiRepository _aiRepository;
  late final AuthCubit _authCubit;
  late final AppConfigCubit _appConfigCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _chatRepository = widget.chatRepository ?? FakeChatRepository();
    _appConfigRepository =
        widget.appConfigRepository ?? FakeAppConfigRepository();
    _translationRepository =
        widget.translationRepository ?? FakeTranslationRepository();
    _aiRepository = widget.aiRepository ?? FakeAiRepository();
    _authCubit = AuthCubit(widget.authRepository)..start();
    _appConfigCubit = AppConfigCubit(_appConfigRepository)..load();
    _appRouter = AppRouter(
      authCubit: _authCubit,
      appConfigCubit: _appConfigCubit,
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    _authCubit.close();
    _appConfigCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: widget.authRepository),
        RepositoryProvider<PostRepository>.value(value: widget.postRepository),
        RepositoryProvider<ChatRepository>.value(value: _chatRepository),
        RepositoryProvider<AppConfigRepository>.value(
          value: _appConfigRepository,
        ),
        RepositoryProvider<TranslationRepository>.value(
          value: _translationRepository,
        ),
        RepositoryProvider<AiRepository>.value(value: _aiRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: _authCubit),
          BlocProvider<AppConfigCubit>.value(value: _appConfigCubit),
        ],
        child: BlocBuilder<AppConfigCubit, AppConfigState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'SoLink',
              debugShowCheckedModeBanner: false,
              theme: buildAppTheme(state.themeColor),
              routerConfig: _appRouter.router,
            );
          },
        ),
      ),
    );
  }
}
