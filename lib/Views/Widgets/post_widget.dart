import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Machine%20learning/language.dart';
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
              Consumer<LanguageProvider>(
                builder: (context, value, child) => TextButton(
                  onPressed: () => value.getLanguageId(texte: post.content),
                  child: Text("Traduire"),
                ),
              ),

              PostReactionWidget(post: post),
            ],
          ),
        ),
      ),
    );
  }
}
