import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_bloc.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_event.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_state.dart';
import 'package:so_link/features/posts/presentation/cubit/post_composer_cubit.dart';
import 'package:so_link/features/posts/presentation/widgets/post_composer.dart';
import 'package:so_link/features/posts/presentation/widgets/post_widgets.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FeedBloc(context.read<PostRepository>())
                ..add(const FeedStarted()),
        ),
        BlocProvider(
          create: (context) => PostComposerCubit(
            aiRepository: context.read<AiRepository>(),
            postRepository: context.read<PostRepository>(),
          ),
        ),
      ],
      child: const _FeedView(),
    );
  }
}

class _FeedView extends StatefulWidget {
  const _FeedView();

  @override
  State<_FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  final _composerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.user;

    return Scaffold(
      key: const ValueKey('feed_screen'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final composerContext = _composerKey.currentContext;
          if (composerContext != null) {
            Scrollable.ensureVisible(
              composerContext,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        },
        child: const Icon(Icons.create),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocListener<FeedBloc, FeedState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<FeedBloc>().add(const FeedErrorDismissed());
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: Row(
                  spacing: 8,
                  children: [
                    const AppLogo(padding: 6, size: 16),
                    Text(
                      'SoLink',
                      style: AppTextStyles.heading.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                key: _composerKey,
                child: const InlinePostComposer(),
              ),
              BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  if (state.status == FeedStatus.loading ||
                      state.status == FeedStatus.initial) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: AppLoading(),
                      ),
                    );
                  }
                  if (state.status == FeedStatus.failure) {
                    return SliverToBoxAdapter(
                      child: AppErrorState(
                        message:
                            state.errorMessage ??
                            'Impossible de charger le feed.',
                        onRetry: () =>
                            context.read<FeedBloc>().add(const FeedRetried()),
                      ),
                    );
                  }
                  if (state.posts.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppEmptyState(
                        message: 'Aucun post pour le moment.',
                        icon: Icons.dynamic_feed_outlined,
                      ),
                    );
                  }
                  if (currentUser == null) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: AppLoading(),
                      ),
                    );
                  }
                  return SliverList.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) => PostCard(
                      key: ValueKey(state.posts[index].id),
                      post: state.posts[index],
                      currentUser: currentUser,
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
