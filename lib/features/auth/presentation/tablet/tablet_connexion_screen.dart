import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:so_link/Models/naviguer_inscription_screen.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';
import 'package:so_link/core/constants.dart';
import 'package:so_link/features/auth/presentation/widgets/connexion_button.dart';
import 'package:so_link/features/auth/presentation/widgets/large_screen_logo_presentation.dart';
import 'package:so_link/features/auth/presentation/widgets/padding_auth_screen_column.dart';

class TabletConnexionScreen extends StatelessWidget {
  const TabletConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: LargeScreenLogoPresentation(
              description: "Connectez-vous avec notre communauté",
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: PaddingAuthScreenColumn(
                paddingHoriz: tabletPaddingHoriz,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bon retour !", style: enteteTexte),
                    const Gap(8),

                    Text(
                      "veuillez vous connecter à votre compte soLink",
                      style: corpsTexte,
                    ),
                    const Gap(20),

                    CustomTextField(
                      values: TextfieldModel(
                        icone: Icons.mail,
                        hintTexte: "ex : djiboismaelzeno@gmail.com",
                        labelTexte: "email",
                        texteController: emailController,
                      ),
                    ),
                    const Gap(16),
                    PasswordTextField(
                      labelTexte: "Mote de passe",
                      hintTexte: "******",
                      icone: Icons.lock,
                      texteController: pwController,
                    ),
                    const Gap(20),
                    ConnexionButton(
                      email: emailController.text,
                      pw: pwController.text,
                    ),
                    const Gap(16),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text("Vous n'avez pas de compte ?", style: corpsTexte),
                        GestureDetector(
                          onTap: () => naviguerInscriptionScreen(context),
                          child: Text(
                            " Créer un compte",
                            style: boutonTexteStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
