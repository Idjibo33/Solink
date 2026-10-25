import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/di/app_dependencies.dart';
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

class SolinkApp extends StatefulWidget {
  const SolinkApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<SolinkApp> createState() => _SolinkAppState();
}

class _SolinkAppState extends State<SolinkApp> {
  late final AuthCubit _authCubit;
  late final AppConfigCubit _appConfigCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(widget.dependencies.authRepository)..start();
    _appConfigCubit = AppConfigCubit(widget.dependencies.appConfigRepository)
      ..load();
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
        RepositoryProvider<AuthRepository>.value(
          value: widget.dependencies.authRepository,
        ),
        RepositoryProvider<PostRepository>.value(
          value: widget.dependencies.postRepository,
        ),
        RepositoryProvider<ChatRepository>.value(
          value: widget.dependencies.chatRepository,
        ),
        RepositoryProvider<AppConfigRepository>.value(
          value: widget.dependencies.appConfigRepository,
        ),
        RepositoryProvider<TranslationRepository>.value(
          value: widget.dependencies.translationRepository,
        ),
        RepositoryProvider<AiRepository>.value(
          value: widget.dependencies.aiRepository,
        ),
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
