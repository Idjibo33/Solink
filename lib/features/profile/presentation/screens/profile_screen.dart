import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_state.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/posts/presentation/widgets/post_widgets.dart';
import 'package:so_link/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:so_link/features/profile/presentation/widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.user;
    if (currentUser == null) {
      return const Scaffold(body: AppLoading());
    }

    return BlocProvider(
      key: ValueKey(currentUser.id),
      create: (context) => ProfileCubit(
        authRepository: context.read<AuthRepository>(),
        postRepository: context.read<PostRepository>(),
        userId: currentUser.id,
      )..load(),
      child: _ProfileView(currentUser: currentUser),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.currentUser});

  final UserModel currentUser;

  Future<void> _editBio(BuildContext context) async {
    final user = context.read<ProfileCubit>().state.user ?? currentUser;
    final controller = TextEditingController(text: user.bio);
    final bio = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifier la bio'),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Parlez de vous en quelques mots',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (bio == null || bio.isEmpty || !context.mounted) {
      return;
    }
    await context.read<AuthCubit>().completeProfile(bio: bio);
  }

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous devrez vous reconnecter pour revenir.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        context.read<AuthCubit>().clearError();
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final user = state.user ?? currentUser;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    title: const Text('Profil'),
                    actions: [
                      IconButton(
                        onPressed: () => _signOut(context),
                        icon: const Icon(Icons.logout),
                        tooltip: 'Se déconnecter',
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      user: user,
                      onEditBio: () => _editBio(context),
                    ),
                  ),
                  if (state.status == ProfileStatus.loading &&
                      state.user == null)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: AppLoading(),
                      ),
                    )
                  else if (state.status == ProfileStatus.failure)
                    SliverToBoxAdapter(
                      child: AppErrorState(
                        message:
                            state.errorMessage ??
                            'Impossible de charger le profil.',
                        onRetry: () => context.read<ProfileCubit>().load(),
                      ),
                    )
                  else if (state.posts.isEmpty)
                    const SliverToBoxAdapter(
                      child: AppEmptyState(
                        message: 'Vous n’avez publié aucun post.',
                        icon: Icons.edit_note,
                      ),
                    )
                  else
                    SliverList.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) => PostCard(
                        key: ValueKey(state.posts[index].id),
                        post: state.posts[index],
                        currentUser: user,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
