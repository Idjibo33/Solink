import 'package:flutter/material.dart';
import 'package:so_link/Views/Widgets/bouton_secondaire.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class ProfilStatistique extends StatelessWidget {
  const ProfilStatistique({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(child: UserAvatar(size: 50)),
            Text("Nom", style: titreTexte),
            Text("Bio", style: corpsTexte),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "10K",
                      style: titreTexte.copyWith(color: couleurePrincipale),
                    ),
                    Text("titre", style: corpsTexte),
                  ],
                ),
                Container(height: 30, width: 2, color: couleurePrincipale),
                Column(
                  children: [
                    Text(
                      "10K",
                      style: titreTexte.copyWith(color: couleurePrincipale),
                    ),
                    Text("titre", style: corpsTexte),
                  ],
                ),
                Container(height: 30, width: 2, color: couleurePrincipale),
                Column(
                  children: [
                    Text(
                      "10K",
                      style: titreTexte.copyWith(color: couleurePrincipale),
                    ),
                    Text("titre", style: corpsTexte),
                  ],
                ),
              ],
            ),
            BoutonSecondaire(boutonTexte: "Modifier profil", action: () {}),
          ],
        ),
      ),
    );
  }
}
