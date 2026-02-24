import 'package:flutter/material.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/post_reaction_widget.dart';
import 'package:so_link/Views/Widgets/post_user_infos.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              PostUserInfos(post: post),
              Text(post.content),
              PostReactionWidget(post: post),
            ],
          ),
        ),
      ),
    );
  }
}
