import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/naviguer_inscription_screen.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/features/auth/logic/providers/auth_services_provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';
import 'package:so_link/core/constants.dart';

class MobileConnexionScreen extends StatelessWidget {
  const MobileConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              LogoWidget(padding: 16, size: 50),
              const Gap(8),
              Text("soLink", style: enteteTexte, textAlign: TextAlign.center),
              const Gap(8),
              Text(
                "veuillez vous connecter à votre compte soLink",
                style: corpsTexte,
              ),
              const Gap(16),
              // Entrée utilisateur
              CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        values: TextfieldModel(
                          icone: Icons.mail,
                          hintTexte: "ex : djiboismaelzeno@gmail.com",
                          labelTexte: "email",
                          texteController: emailController,
                        ),
                      ),
                      const Gap(8),
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
              const Gap(16),
              Consumer<AuthServicesProvider>(
                builder: (context, auth, child) => BoutonPrincipale(
                  texteBouton: "Se connecter",
                  action: () => auth.connecterUtilisateur(
                    email: emailController.text,
                    pw: pwController.text,
                  ),
                  chargement: auth.chargement,
                ),
              ),
              const Gap(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
