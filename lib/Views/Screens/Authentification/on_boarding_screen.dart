import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/naviguer_auth_gate.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final user = context.watch<UtililsateurProvider>().id;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserAvatar(size: 50),
                Text("Parlez-nous de vous", style: enteteTexte),
                Text(
                  "Votre bio aide les autres à vous trouver et à comprendre ce que vous faites",
                  style: corpsTexte,
                  textAlign: TextAlign.center,
                ),
                CustomTextField(
                  values: TextfieldModel(
                    lines: 5,
                    hintTexte:
                        "ex : Developpeur flutter | passionné par le digital",
                    labelTexte: "Bio",
                    texteController: textController,
                  ),
                ),
                Gap(20),
                Consumer<UtililsateurProvider>(
                  builder: (context, value, child) => BoutonPrincipale(
                    texteBouton: "Ajouter bio",
                    action: () async {
                      await value.ajouterBio(
                        userId: user!,
                        bio: textController.text,
                      );
                      if (context.mounted) naviguerAuthGate(context);
                    },
                    chargement: value.chargement,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
