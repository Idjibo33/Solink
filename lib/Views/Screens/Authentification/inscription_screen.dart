import 'package:flutter/material.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/constants.dart';

class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                LogoWidget(padding: 16, size: 50),
                // Entrée utilisateur
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(width: 1, color: couleureSecondaire),
                    color: couleureBlancheDark,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      spacing: 12,
                      children: [
                        CustomTextField(
                          labelTexte: "Nom",
                          hintTexte: "ex : Djibo Adamou",
                          icone: Icons.person,
                          cacherContenu: false,
                        ),
                        CustomTextField(
                          labelTexte: "Prenom",
                          hintTexte: "ex : Ismael",
                          icone: Icons.person,
                          cacherContenu: false,
                        ),
                        CustomTextField(
                          labelTexte: "email",
                          hintTexte: "ex : djiboismaelzeno@gmail.com",
                          icone: Icons.mail,
                          cacherContenu: false,
                        ),
                        CustomTextField(
                          labelTexte: "Mot de passe",
                          hintTexte: "******",
                          icone: Icons.lock,
                          cacherContenu: true,
                        ),
                      ],
                    ),
                  ),
                ),
                BoutonPrincipale(
                  texteBouton: "S'inscrire",
                  action: () {},
                  chargement: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
