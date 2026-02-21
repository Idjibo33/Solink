import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Auth/inscription_provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';

class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nomController = TextEditingController();
    final prenomController = TextEditingController();
    final emailController = TextEditingController();
    final pwController = TextEditingController();
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      spacing: 12,
                      children: [
                        CustomTextField(
                          labelTexte: "Nom",
                          hintTexte: "ex : Djibo Adamou",
                          icone: Icons.person,
                          texteController: nomController,
                        ),
                        CustomTextField(
                          labelTexte: "Prenom",
                          hintTexte: "ex : Ismael",
                          icone: Icons.person,
                          texteController: prenomController,
                        ),
                        CustomTextField(
                          labelTexte: "email",
                          hintTexte: "ex : djiboismaelzeno@gmail.com",
                          icone: Icons.mail,
                          texteController: emailController,
                        ),
                        PasswordTextField(
                          labelTexte: "Mot de passe",
                          hintTexte: "******",
                          icone: Icons.lock,
                          texteController: pwController,
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<InscriptionProvider>(
                  builder: (context, value, child) => BoutonPrincipale(
                    texteBouton: "S'inscrire",
                    action: () => value.inscrireUtilisateur(
                      context: context,
                      nom: nomController.text,
                      prenom: prenomController.text,
                      email: emailController.text,
                      pw: pwController.text,
                    ),
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
