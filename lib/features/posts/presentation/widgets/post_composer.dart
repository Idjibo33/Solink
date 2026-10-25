import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/posts/presentation/cubit/post_composer_cubit.dart';

class InlinePostComposer extends StatefulWidget {
  const InlinePostComposer({super.key});

  @override
  State<InlinePostComposer> createState() => _InlinePostComposerState();
}

class _InlinePostComposerState extends State<InlinePostComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _publish() {
    final user = context.read<AuthCubit>().state.user;
    if (user == null) {
      return;
    }
    context.read<PostComposerCubit>().publish(
      author: user,
      content: _controller.text,
    );
  }

  void _openAiSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PostGenerationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostComposerCubit, PostComposerState>(
      listenWhen: (previous, current) =>
          (current.published && !previous.published) ||
          (current.errorMessage != null &&
              previous.errorMessage != current.errorMessage),
      listener: (context, state) {
        if (state.published) {
          _controller.clear();
          context.read<PostComposerCubit>().consumePublished();
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<PostComposerCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: GlassContainer(
            child: Column(
              spacing: 10,
              children: [
                SimpleTextField(
                  controller: _controller,
                  hint: "Qu'avez-vous en tête ?",
                  minLines: 1,
                  maxLines: 4,
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Publier',
                        isLoading: state.isPublishing,
                        onPressed: _publish,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: _openAiSheet,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.5),
                              Colors.redAccent.withValues(alpha: 0.3),
                              Colors.orangeAccent.withValues(alpha: 0.3),
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary,
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

class PostGenerationSheet extends StatelessWidget {
  const PostGenerationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostComposerCubit(
        aiRepository: context.read<AiRepository>(),
        postRepository: context.read<PostRepository>(),
      ),
      child: const _PostGenerationSheetBody(),
    );
  }
}

class _PostGenerationSheetBody extends StatefulWidget {
  const _PostGenerationSheetBody();

  @override
  State<_PostGenerationSheetBody> createState() =>
      _PostGenerationSheetBodyState();
}

class _PostGenerationSheetBodyState extends State<_PostGenerationSheetBody> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _publish(UserModel author) {
    context.read<PostComposerCubit>().publish(
      author: author,
      content: _controller.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final author = context.read<AuthCubit>().state.user;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: BlocConsumer<PostComposerCubit, PostComposerState>(
          listenWhen: (previous, current) =>
              (current.generatedText != null &&
                  previous.generatedText != current.generatedText) ||
              (current.published && !previous.published) ||
              (current.errorMessage != null &&
                  previous.errorMessage != current.errorMessage),
          listener: (context, state) {
            if (state.generatedText != null) {
              _controller.text = state.generatedText!;
              _controller.selection = TextSelection.collapsed(
                offset: _controller.text.length,
              );
            }
            if (state.published) {
              Navigator.of(context).pop();
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              context.read<PostComposerCubit>().clearError();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Créer un post avec l'IA",
                        style: AppTextStyles.title.copyWith(color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  AppTextField(
                    controller: _controller,
                    label: 'Sujet du post',
                    hint: 'De quoi le texte doit-il parler ?',
                    icon: Icons.text_fields,
                    lines: 5,
                  ),
                  PrimaryButton(
                    label: state.generatedText == null
                        ? 'Générer avec l\'IA'
                        : 'Régénérer',
                    isLoading: state.isGenerating,
                    onPressed: () => context.read<PostComposerCubit>().generate(
                      _controller.text,
                    ),
                  ),
                  if (author != null && state.generatedText != null)
                    PrimaryButton(
                      label: 'Publier',
                      isLoading: state.isPublishing,
                      onPressed: () => _publish(author),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
