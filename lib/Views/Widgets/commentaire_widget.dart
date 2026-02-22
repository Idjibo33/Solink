import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/gerer_timestamp.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class CommentaireWidget extends StatelessWidget {
  final Commentaire commentaire;
  const CommentaireWidget({super.key, required this.commentaire});

  @override
  Widget build(BuildContext context) {
    final userProvider = context
        .watch<UtililsateurProvider>()
        .utilisateurServices;
    final date = gererTimeStamp(commentaire.creeLe);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      UserAvatar(size: 25),
                      StreamBuilder(
                        stream: userProvider.lireDocUser(commentaire.userId),
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
                    ],
                  ),
                  Text(date, style: corpsTexte),
                ],
              ),
              Text(
                commentaire.content,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
