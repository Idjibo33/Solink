import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/Views/Widgets/custom_icon_button.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/password_text_field.dart';
import 'package:so_link/core/constants.dart';
import 'package:so_link/features/auth/presentation/widgets/inscription_button.dart';
import 'package:so_link/features/auth/presentation/widgets/large_screen_logo_presentation.dart';
import 'package:so_link/features/auth/presentation/widgets/padding_auth_screen_column.dart';

class TabletInscriptionScreen extends StatefulWidget {
  const TabletInscriptionScreen({super.key});

  @override
  State<TabletInscriptionScreen> createState() =>
      _TabletInscriptionScreenState();
}

class _TabletInscriptionScreenState extends State<TabletInscriptionScreen> {
  late TextEditingController nomController;

  late TextEditingController prenomController;

  late TextEditingController emailController;

  late TextEditingController pwController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController();

    prenomController = TextEditingController();

    emailController = TextEditingController();

    pwController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: LargeScreenLogoPresentation(
              description: "Commencez votre expérience",
            ),
          ),
          Expanded(
            child: PaddingAuthScreenColumn(
              paddingHoriz: tabletPaddingHoriz,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconButton(
                    action: () {
                      Navigator.pop(context);
                    },
                    icone: Icons.arrow_back,
                  ),
                  Text("Créer un compte", style: enteteTexte),
                  const Gap(8),

                  Text(
                    "Rejoignez la communauté soLink dès maintenant",
                    style: corpsTexte,
                  ),
                  const Gap(20),
                  // Entrée utilisateur
                  CustomTextField(
                    values: TextfieldModel(
                      icone: Icons.person,
                      hintTexte: "ex : Djibo Adamou",
                      labelTexte: "Nom",
                      texteController: nomController,
                    ),
                  ),
                  const Gap(12),
                  CustomTextField(
                    values: TextfieldModel(
                      icone: Icons.person,
                      hintTexte: "ex : Ismael",
                      labelTexte: "Prenom",
                      texteController: prenomController,
                    ),
                  ),
                  const Gap(12),
                  CustomTextField(
                    values: TextfieldModel(
                      icone: Icons.mail,
                      hintTexte: "ex : djiboismaelzeno@gmail.com",
                      labelTexte: "email",
                      texteController: emailController,
                    ),
                  ),
                  const Gap(12),
                  PasswordTextField(
                    labelTexte: "Mot de passe",
                    hintTexte: "******",
                    icone: Icons.lock,
                    texteController: pwController,
                  ),
                  const Gap(20),
                  InscriptionButton(
                    nom: nomController.text,
                    prenom: prenomController.text,
                    email: emailController.text,
                    pw: pwController.text,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
