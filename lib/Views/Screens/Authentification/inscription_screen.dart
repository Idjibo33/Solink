import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';
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
                CustomContainer(
                  children: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      spacing: 12,
                      children: [
                        CustomTextField(
                          labelTexte: "Nom",
                          hintTexte: "ex : Djibo Adamou",
                          icone: Icons.person,
                        ),
                        CustomTextField(
                          labelTexte: "Prenom",
                          hintTexte: "ex : Ismael",
                          icone: Icons.person,
                        ),
                        CustomTextField(
                          labelTexte: "email",
                          hintTexte: "ex : djiboismaelzeno@gmail.com",
                          icone: Icons.mail,
                        ),
                        PasswordTextField(
                          labelTexte: "Mot de passe",
                          hintTexte: "******",
                          icone: Icons.lock,
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
