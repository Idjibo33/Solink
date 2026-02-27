import 'package:flutter/material.dart';
import 'package:so_link/Models/gerer_timestamp.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/Models/constants.dart';

class PostUserInfos extends StatelessWidget {
  final PostModel post;
  const PostUserInfos({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final postDate = gererTimeStamp(post.creeLe);
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvatar(size: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.userName, style: titreTexte, textAlign: TextAlign.start),

            Text(postDate.toString(), style: corpsTexte),
          ],
        ),
      ],
    );
  }
}
