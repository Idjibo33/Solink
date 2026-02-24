import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
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
                BoutonPrincipale(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
