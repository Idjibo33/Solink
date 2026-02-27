import 'package:flutter/material.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/gerer_timestamp.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/Models/constants.dart';

class CommentaireUserInfos extends StatelessWidget {
  final Commentaire commentaire;
  const CommentaireUserInfos({super.key, required this.commentaire});

  @override
  Widget build(BuildContext context) {
    final postDate = gererTimeStamp(commentaire.creeLe);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserAvatar(size: 25),
            Text(
              commentaire.userName,
              style: titreTexte,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Text(postDate.toString(), style: corpsTexte),
      ],
    );
  }
}
