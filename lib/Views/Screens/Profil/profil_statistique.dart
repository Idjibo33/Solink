import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/bouton_secondaire.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class ProfilStatistique extends StatelessWidget {
  const ProfilStatistique({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UtililsateurProvider>(
      builder: (context, value, child) => StreamBuilder(
        stream: value.userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    SizedBox(child: UserAvatar(size: 50)),
                    Text(
                      "${snapshot.data!.nom} ${snapshot.data!.prenom}",
                      style: titreTexte,
                    ),
                    Text(
                      snapshot.data!.bio,
                      style: corpsTexte,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              snapshot.data!.nombrePosts.toString(),
                              style: titreTexte.copyWith(
                                color: couleurePrincipale,
                              ),
                            ),
                            Text("Posts", style: corpsTexte),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 2,
                          color: couleurePrincipale,
                        ),
                        Column(
                          children: [
                            Text(
                              snapshot.data!.followers.toString(),
                              style: titreTexte.copyWith(
                                color: couleurePrincipale,
                              ),
                            ),
                            Text("Followers", style: corpsTexte),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 2,
                          color: couleurePrincipale,
                        ),
                        Column(
                          children: [
                            Text(
                              snapshot.data!.followings.toString(),
                              style: titreTexte.copyWith(
                                color: couleurePrincipale,
                              ),
                            ),
                            Text("Followings", style: corpsTexte),
                          ],
                        ),
                      ],
                    ),
                    BoutonSecondaire(
                      boutonTexte: "Modifier profil",
                      action: () {},
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
