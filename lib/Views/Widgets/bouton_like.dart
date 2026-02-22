import 'package:flutter/material.dart';
import 'package:so_link/Services/Firebase/Firestore/post.dart';
import 'package:so_link/constants.dart';

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
      if (isLiked) {
        Post().removeLike(widget.docId);
      } else {
        Post().addLike(widget.docId);
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
        color: couleurePrincipale.withValues(alpha: 0.5),
      ),
    );
  }
}
