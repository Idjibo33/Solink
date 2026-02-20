import 'package:flutter/material.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/constants.dart';

class NewPost1 extends StatelessWidget {
  const NewPost1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomContainer(
        children: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                child: TextField(
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
                action: () {},
                chargement: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
