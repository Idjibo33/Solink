import 'package:flutter/material.dart';
import 'package:so_link/Models/naviguer_inscription_screen.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';
import 'package:so_link/constants.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                        labelTexte: "email",
                        hintTexte: "ex : djiboismaelzeno@gmail.com",
                        icone: Icons.mail,
                      ),
                      PasswordTextField(
                        labelTexte: "Mote de passe",
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Vous n'avez pas de compte ?", style: corpsTexte),
                  GestureDetector(
                    onTap: () => naviguerInscriptionScreen(context),
                    child: Text(" Créer un compte", style: boutonTexteStyle),
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
