import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_state.dart';
import 'package:so_link/features/auth/presentation/screens/auth_screens.dart';
import 'package:so_link/features/chats/presentation/screens/chat_screens.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/presentation/screens/comments_screen.dart';
import 'package:so_link/features/posts/presentation/screens/feed_screen.dart';
import 'package:so_link/features/profile/presentation/screens/profile_screen.dart';
import 'package:so_link/features/settings/presentation/cubit/app_config_cubit.dart';
import 'package:so_link/features/settings/presentation/screens/settings_screens.dart';

class AppRouter {
  AppRouter({
    required AuthCubit authCubit,
    required AppConfigCubit appConfigCubit,
  }) {
    _refreshStreams = [
      GoRouterRefreshStream(authCubit.stream),
      GoRouterRefreshStream(appConfigCubit.stream),
    ];
    router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: Listenable.merge(_refreshStreams),
      redirect: (context, state) {
        final path = state.uri.path;
        final authState = authCubit.state;
        final configState = appConfigCubit.state;

        if (configState.isLoading) {
          return path == '/splash' ? null : '/splash';
        }
        if (configState.maintenance) {
          return path == '/maintenance' ? null : '/maintenance';
        }
        if (configState.updateRequired) {
          return path == '/update' ? null : '/update';
        }
        if (path == '/maintenance' || path == '/update') {
          return switch (authState.status) {
            AuthStatus.unknown => '/splash',
            AuthStatus.unauthenticated => '/login',
            AuthStatus.needsProfile => '/onboarding',
            AuthStatus.authenticated => '/feed',
          };
        }

        return _redirectForAuth(path, authState);
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/maintenance',
          builder: (context, state) => const MaintenanceScreen(),
        ),
        GoRoute(
          path: '/update',
          builder: (context, state) => const RequiredUpdateScreen(),
        ),
        GoRoute(
          path: '/comments/:postId',
          builder: (context, state) => CommentsScreen(
            postId: state.pathParameters['postId']!,
            initialPost: state.extra as PostModel?,
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/feed',
                  builder: (context, state) => const FeedScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/chats',
                  builder: (context, state) => const ConversationsScreen(),
                  routes: [
                    GoRoute(
                      path: ':userId',
                      builder: (context, state) => ChatRoomScreen(
                        receiverId: state.pathParameters['userId']!,
                        initialReceiver: state.extra as UserModel?,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  late final List<GoRouterRefreshStream> _refreshStreams;
  late final GoRouter router;

  void dispose() {
    router.dispose();
    for (final stream in _refreshStreams) {
      stream.dispose();
    }
  }

  static String? _redirectForAuth(String path, AuthState authState) {
    final isAuthRoute = path == '/login' || path == '/register';

    return switch (authState.status) {
      AuthStatus.unknown => path == '/splash' ? null : '/splash',
      AuthStatus.unauthenticated => isAuthRoute ? null : '/login',
      AuthStatus.needsProfile => path == '/onboarding' ? null : '/onboarding',
      AuthStatus.authenticated =>
        isAuthRoute || path == '/onboarding' || path == '/splash'
            ? '/feed'
            : null,
    };
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dynamic_feed_outlined),
            selectedIcon: Icon(Icons.dynamic_feed),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
