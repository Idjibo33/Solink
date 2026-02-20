import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/naviguer_inscription_screen.dart';
import 'package:so_link/Providers/Auth/connexion_provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';
import 'package:so_link/constants.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();
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
              CustomContainer(
                children: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 12,
                    children: [
                      CustomTextField(
                        labelTexte: "email",
                        hintTexte: "ex : djiboismaelzeno@gmail.com",
                        icone: Icons.mail,
                        texteController: emailController,
                      ),
                      PasswordTextField(
                        labelTexte: "Mote de passe",
                        hintTexte: "******",
                        icone: Icons.lock,
                        texteController: pwController,
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<ConnexionProvider>(
                builder: (context, value, child) => BoutonPrincipale(
                  texteBouton: "Se connecter",
                  action: () => value.connecterUtilisateur(
                    context: context,
                    email: emailController.text,
                    pw: pwController.text,
                  ),
                  chargement: value.chargement,
                ),
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
