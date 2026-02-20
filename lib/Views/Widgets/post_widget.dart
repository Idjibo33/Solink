import 'package:flutter/material.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: CustomContainer(
        children: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatar(size: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("nom", style: titreTexte),
                    Text("Il y a une minute", style: corpsTexte),
                  ],
                ),
              ],
            ),
            Text(
              'Post textePost textePost textePost textePost textePost textePost textePost textePost textePost texte',
              style: postTexte,
            ),
            Row(
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.favorite,
                        color: couleurePrincipale.withValues(alpha: 0.5),
                      ),
                    ),
                    Text("1"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.comment,
                        color: couleurePrincipale.withValues(alpha: 0.5),
                      ),
                    ),
                    Text("1"),
                  ],
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
