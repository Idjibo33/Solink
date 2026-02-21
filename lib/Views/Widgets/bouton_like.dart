import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/constants.dart';

class BoutonLike extends StatefulWidget {
  final String postId;
  const BoutonLike({super.key, required this.postId});

  @override
  State<BoutonLike> createState() => _BoutonLikeState();
}

class _BoutonLikeState extends State<BoutonLike> {
  @override
  Widget build(BuildContext context) {
    final postActionProvider = context.watch<PostsProvider>();
    bool liked = false;
    void changerLike() {
      setState(() {
        liked = !liked;
      });
    }

    return Stack(
      children: [
        liked
            ? GestureDetector(
                onTap: () {
                  changerLike();
                },

                child: Icon(
                  Icons.favorite,
                  color: couleurePrincipale.withValues(alpha: 0.5),
                ),
              )
            : GestureDetector(
                onTap: () {
                  changerLike();
                  postActionProvider.likePost(
                    context: context,
                    postId: widget.postId,
                  );
                },
                child: Icon(
                  Icons.favorite_border_outlined,
                  color: couleurePrincipale.withValues(alpha: 0.5),
                ),
              ),
      ],
    );
  }
}
