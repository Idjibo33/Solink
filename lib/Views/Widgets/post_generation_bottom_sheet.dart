import 'package:flutter/material.dart';
import 'package:so_link/Models/constants.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/Views/Widgets/ai_generating_button.dart';
import 'package:so_link/Views/Widgets/custom_text_field.dart';
import 'package:so_link/Views/Widgets/simple_text_field.dart';

class PostGenerationBottomSheet extends StatefulWidget {
  const PostGenerationBottomSheet({super.key});

  @override
  State<PostGenerationBottomSheet> createState() =>
      _PostGenerationBottomSheetState();
}

class _PostGenerationBottomSheetState extends State<PostGenerationBottomSheet> {
  final texteController = TextEditingController();
  @override
  void initState() {
    super.initState();
    texteController;
  }

  @override
  void dispose() {
    texteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 350,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: SafeArea(
              child: Column(
                spacing: 8,
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
                  CustomTextField(
                    values: TextfieldModel(
                      hintTexte: "De quoi le texte doit s'agir",
                      labelTexte: "Description du post",
                      texteController: texteController,
                      lines: 4,
                      icone: Icons.text_fields,
                    ),
                  ),
                  Spacer(),
                  AiGeneratingButton(
                    action: () {
                      Navigator.pop(context);
                    },
                    chargement: false,
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
