import 'package:flutter/material.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class CommentaireWidget extends StatelessWidget {
  const CommentaireWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: couleureBlancheDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      UserAvatar(size: 25),
                      Text('Text', style: titreTexte),
                    ],
                  ),
                  Text('Text', style: corpsTexte),
                ],
              ),
              Text(
                "ContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContentContent",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
