import 'package:flutter/material.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Views/Screens/Commentaires/commentaire_user_infos.dart';

class CommentaireWidget extends StatelessWidget {
  final Commentaire commentaire;
  const CommentaireWidget({super.key, required this.commentaire});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              CommentaireUserInfos(commentaire: commentaire),

              Text(
                commentaire.content,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
