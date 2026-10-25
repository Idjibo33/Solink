import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/posts/presentation/cubit/comments_cubit.dart';
import 'package:so_link/features/posts/presentation/widgets/comment_tile.dart';
import 'package:so_link/features/posts/presentation/widgets/post_widgets.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key, required this.postId, this.initialPost});

  final String postId;
  final PostModel? initialPost;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CommentsCubit(context.read<PostRepository>())..load(postId),
      child: _CommentsView(postId: postId, initialPost: initialPost),
    );
  }
}

class _CommentsView extends StatefulWidget {
  const _CommentsView({required this.postId, this.initialPost});

  final String postId;
  final PostModel? initialPost;

  @override
  State<_CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<_CommentsView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final user = context.read<AuthCubit>().state.user;
    if (user == null) {
      return;
    }
    final cubit = context.read<CommentsCubit>();
    await cubit.addComment(author: user, content: _controller.text);
    if (mounted && cubit.state.errorMessage == null) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Commentaires')),
      body: SafeArea(
        child: BlocConsumer<CommentsCubit, CommentsState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<CommentsCubit>().clearError();
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(child: _buildList(state, currentUser)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                  child: Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: SimpleTextField(
                          controller: _controller,
                          hint: 'Ajouter un commentaire',
                        ),
                      ),
                      IconButton(
                        onPressed: state.isSending ? null : _send,
                        icon: state.isSending
                            ? const AppLoading(size: 18)
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(CommentsState state, UserModel? currentUser) {
    if (state.status == CommentsStatus.loading ||
        state.status == CommentsStatus.initial) {
      return const AppLoading();
    }
    if (state.status == CommentsStatus.failure) {
      return AppErrorState(
        message:
            state.errorMessage ?? 'Impossible de charger les commentaires.',
        onRetry: () => context.read<CommentsCubit>().load(widget.postId),
      );
    }
    if (state.comments.isEmpty && widget.initialPost == null) {
      return const AppEmptyState(
        message: 'Aucun commentaire pour le moment.',
        icon: Icons.comment_outlined,
      );
    }

    final hasPost = widget.initialPost != null && currentUser != null;
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: state.comments.length + (hasPost ? 1 : 0),
      itemBuilder: (context, index) {
        if (hasPost && index == 0) {
          return PostCard(
            post: widget.initialPost!,
            currentUser: currentUser,
            showCommentsButton: false,
          );
        }
        final commentIndex = hasPost ? index - 1 : index;
        return CommentTile(comment: state.comments[commentIndex]);
      },
    );
  }
}
