import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/constants.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/Providers/Ai%20logic/ai_logic_provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/ai_generating_button.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';

class PostGenerationBottomSheet extends StatefulWidget {
  const PostGenerationBottomSheet({super.key});

  @override
  State<PostGenerationBottomSheet> createState() =>
      _PostGenerationBottomSheetState();
}

class _PostGenerationBottomSheetState extends State<PostGenerationBottomSheet> {
  TextEditingController texteController = TextEditingController();
  bool? showPublishButton;
  @override
  void initState() {
    super.initState();
    texteController;
    showPublishButton = false;
  }

  @override
  void dispose() {
    texteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UtililsateurProvider>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 370,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
            child: SafeArea(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Crée un post avec l'IA",
                        style: titreTexte.copyWith(color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Gap(12),
                  CustomTextField(
                    values: TextfieldModel(
                      hintTexte: "De quoi le texte doit s'agir",
                      texteController: texteController,
                      lines: 5,
                      icone: Icons.text_fields,
                      labelTexte: "",
                    ),
                  ),
                  Gap(12),
                  Consumer2<AiLogicProvider, PostsProvider>(
                    builder: (context, aiLogic, post, child) {
                      if (showPublishButton!) {
                        return BoutonPrincipale(
                          texteBouton: "Publiez",
                          action: () async {
                            await post.ajouterPost(
                              newpost: PostModel(
                                comments: 0,
                                userName: "",
                                id: "",
                                userId: "",
                                content: texteController.text,
                                creeLe: Timestamp.now(),
                                likes: [],
                              ),
                              userId: user.id!,
                            );

                            texteController.clear();
                            if (context.mounted) Navigator.pop(context);
                          },
                          chargement: post.chargement,
                        );
                      } else {
                        return AiGeneratingButton(
                          action: () async {
                            final texteGeneree = await aiLogic
                                .generatePostTexte(
                                  prompt: texteController.text,
                                );

                            setState(() {
                              texteController.text = texteGeneree!;
                              showPublishButton = true;
                            });
                          },
                          chargement: aiLogic.chargement,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
