import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';

class BoutonLike extends StatefulWidget {
  final List likes;
  final String docId;
  final String userId;
  const BoutonLike({
    super.key,
    required this.likes,
    required this.docId,
    required this.userId,
  });

  @override
  State<BoutonLike> createState() => _BoutonLikeState();
}

class _BoutonLikeState extends State<BoutonLike> {
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    void changerReaction() {
      final post = context.read<PostsProvider>();
      if (isLiked) {
        post.removeLike(docId: widget.docId, userId: widget.userId);
      } else {
        post.addLike(docId: widget.docId, userId: widget.userId);
      }
    }

    return IconButton(
      onPressed: () {
        changerReaction();
        setState(() {
          isLiked = !isLiked;
        });
      },
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
