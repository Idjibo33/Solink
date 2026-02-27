import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/bouton_like.dart';
import 'package:so_link/Views/Screens/Commentaires/commentaires_screen.dart';
import 'package:so_link/Models/constants.dart';

class PostReactionWidget extends StatelessWidget {
  final PostModel post;
  const PostReactionWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UtililsateurProvider>();

    return Row(
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BoutonLike(likes: post.likes, docId: post.id, userId: user.id!),
            Text(post.likes.length.toString()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentairesScreen(post: post),
                ),
              ),
              icon: Icon(
                Icons.comment,
                color: couleurePrincipale.withValues(alpha: 0.5),
              ),
            ),
            Text(post.comments.toString()),
          ],
        ),
      ],
    );
  }
}
