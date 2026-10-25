import 'package:flutter/material.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user, required this.onEditBio});

  final UserModel user;
  final VoidCallback onEditBio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          children: [
            UserAvatar(username: user.displayName, size: 40),
            Text(user.displayName, style: AppTextStyles.heading),
            Text(
              user.bio.isEmpty ? 'Aucune bio pour le moment.' : user.bio,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(label: 'Posts', value: user.posts),
                _Divider(),
                _Stat(label: 'Followers', value: user.followers),
                _Divider(),
                _Stat(label: 'Followings', value: user.followings),
              ],
            ),
            SecondaryButton(label: 'Modifier la bio', onPressed: onEditBio),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTextStyles.title.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 1.5,
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
    );
  }
}
