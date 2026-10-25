import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/utils/date_formatter.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/posts/presentation/cubit/post_card_cubit.dart';
import 'package:so_link/features/translation/domain/repositories/translation_repository.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.currentUser,
    this.showCommentsButton = true,
  });

  final PostModel post;
  final UserModel currentUser;
  final bool showCommentsButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCardCubit(
        translationRepository: context.read<TranslationRepository>(),
        postRepository: context.read<PostRepository>(),
      ),
      child: _PostCardBody(
        post: post,
        currentUser: currentUser,
        showCommentsButton: showCommentsButton,
      ),
    );
  }
}

class _PostCardBody extends StatelessWidget {
  const _PostCardBody({
    required this.post,
    required this.currentUser,
    required this.showCommentsButton,
  });

  final PostModel post;
  final UserModel currentUser;
  final bool showCommentsButton;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCardCubit, PostCardState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        context.read<PostCardCubit>().clearError();
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: GlassContainer(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                PostHeader(post: post),
                Text(
                  post.content,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                _TranslationSection(post: post, state: state),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: state.isReacting
                          ? null
                          : () => context.read<PostCardCubit>().toggleLike(
                              post: post,
                              userId: currentUser.id,
                            ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          spacing: 6,
                          children: [
                            if (state.isReacting)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Icon(
                                post.isLikedBy(currentUser.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                                size: 22,
                              ),
                            Text(
                              '${post.likes.length}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (showCommentsButton)
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () =>
                            context.push('/comments/${post.id}', extra: post),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Row(
                            spacing: 6,
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.6),
                                size: 22,
                              ),
                              Text(
                                '${post.comments}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        UserAvatar(username: post.userName, size: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: AppTextStyles.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(formatTimestamp(post.creeLe), style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

class _TranslationSection extends StatelessWidget {
  const _TranslationSection({required this.post, required this.state});

  final PostModel post;
  final PostCardState state;

  @override
  Widget build(BuildContext context) {
    if (state.translation != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          state.translation!,
          style: AppTextStyles.body.copyWith(color: Colors.black87),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: state.isTranslating
            ? null
            : () => context.read<PostCardCubit>().translate(post.content),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Icon(
                Icons.translate,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                state.isTranslating ? 'Traduction...' : 'Traduire',
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
