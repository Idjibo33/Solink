import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Views/Widgets/commentaire_widget.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/post_widget.dart';
import 'package:so_link/constants.dart';

class CommentairesScreen extends StatefulWidget {
  final PostModel post;
  const CommentairesScreen({super.key, required this.post});

  @override
  State<CommentairesScreen> createState() => _CommentairesScreenState();
}

class _CommentairesScreenState extends State<CommentairesScreen> {
  final textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostWidget(post: widget.post),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => CommentaireWidget(),
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: "Ajouter un commentaire",
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
                  Consumer<PostsProvider>(
                    builder: (context, value, child) => IconButton(
                      onPressed: () async {
                        await value.addComment(
                          context: context,
                          commentaire: Commentaire(
                            id: "",
                            content: textController.text,
                            userId: '',
                            creeLe: Timestamp.now(),
                          ),
                          docId: widget.post.id,
                        );
                        textController.clear();
                      },
                      icon: value.chargement
                          ? CircularProgressIndicator.adaptive()
                          : Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
