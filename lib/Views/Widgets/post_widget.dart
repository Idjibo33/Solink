import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/gerer_timestamp.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/bouton_like.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final postDate = gererTimeStamp(post.creeLe);
    final userProvider = UtililsateurProvider().utilisateurServices;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      StreamBuilder(
                        stream: userProvider.lireDocUser(post.userId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                          return Text(
                            snapshot.data!.nom,
                            style: titreTexte,
                            textAlign: TextAlign.start,
                          );
                        },
                      ),

                      Text(postDate.toString(), style: corpsTexte),
                    ],
                  ),
                ],
              ),
              Text(post.content),

              Row(
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BoutonLike(
                        likes: post.likes,
                        docId: post.id,
                        userId: userProvider.docId!,
                      ),

                      Text(post.likes.length.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.comment,
                          color: couleurePrincipale.withValues(alpha: 0.5),
                        ),
                      ),
                      Text("1"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
