import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/constants.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Services/Firebase/Ai%20Logic/ai_services.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/post_generation_bottom_sheet.dart';
import 'package:so_link/Views/Widgets/simple_text_field.dart';

class NewPost1 extends StatelessWidget {
  const NewPost1({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UtililsateurProvider>();
    final texteController = TextEditingController();
    return Consumer<PostsProvider>(
      builder: (context, value, child) => SizedBox(
        child: CustomContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Column(
              spacing: 8,
              children: [
                SizedBox(
                  child: SimpleTextField(
                    hint: "Qu'avez-vous en tête ?",
                    controller: texteController,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: BoutonPrincipale(
                        texteBouton: "Publiez",
                        action: () async {
                          await value.ajouterPost(
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
                        },
                        chargement: value.chargement,
                      ),
                    ),
                    Gap(8),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => PostGenerationBottomSheet(),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: couleurePrincipale,
                          ),
                          gradient: LinearGradient(
                            begin: AlignmentGeometry.topLeft,
                            end: AlignmentGeometry.bottomRight,

                            colors: [
                              couleurePrincipale.withValues(alpha: 0.5),
                              Colors.redAccent.withValues(alpha: 0.3),
                              Colors.orangeAccent.withValues(alpha: 0.3),
                              couleurePrincipale.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lightbulb,
                            color: couleurePrincipale,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
