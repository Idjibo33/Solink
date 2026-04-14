import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/naviguer_inscription_screen.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/Providers/Auth/auth_services_provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';
import 'package:so_link/core/constants.dart';
import 'package:so_link/features/auth/presentation/widgets/large_screen_logo_presentation.dart';
import 'package:so_link/features/auth/presentation/widgets/padding_auth_screen_column.dart';

class DesktopConnexionScreen extends StatelessWidget {
  const DesktopConnexionScreen({super.key});

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
                paddingHoriz: desktopPaddingHoriz,
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
                    const Gap(16),
                    Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
