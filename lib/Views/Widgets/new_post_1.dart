import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/constants.dart';

class NewPost1 extends StatelessWidget {
  const NewPost1({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: TextField(
                    controller: texteController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Qu'avez-vous en tête ?",
                      hintStyle: hintText,
                      filled: true,
                      fillColor: couleureSecondaire,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                BoutonPrincipale(
                  texteBouton: "Publiez",
                  action: () async {
                    await value.ajouterPost(
                      context: context,
                      newpost: PostModel(
                        id: "",
                        userId: "",
                        content: texteController.text,
                        creeLe: Timestamp.now(),
                        likes: [],
                      ),
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
