import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/commentaire_widget.dart';
import 'package:so_link/Views/Widgets/loading_widget.dart';
import 'package:so_link/Views/Widgets/simple_text_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    final user = context.watch<UtililsateurProvider>().id;
    bool chargement = true;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<PostsProvider>(
              builder: (context, value, child) => StreamBuilder(
                stream: value.readcomments(docId: widget.post.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    chargement = true;
                    return LoadingWidget();
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    chargement = false;
                    return Expanded(
                      child: Skeletonizer(
                        enabled: chargement,
                        child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) => CommentaireWidget(
                            commentaire: snapshot.data![index],
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.data == null) {
                    return Center(child: Text("Aucun commentaire trouvé"));
                  }
                  return Center(child: Text(snapshot.error.toString()));
                },
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: SimpleTextField(
                      controller: textController,
                      hint: "ajouter un commentaire",
                    ),
                  ),
                  Consumer<PostsProvider>(
                    builder: (context, value, child) => IconButton(
                      onPressed: () async {
                        await value.addComment(
                          context: context,
                          commentaire: Commentaire(
                            userName: '',
                            id: "",
                            content: textController.text,
                            userId: '',
                            creeLe: Timestamp.now(),
                          ),
                          docId: widget.post.id,
                          userId: user!,
                        );
                        textController.clear();
                      },
                      icon: value.chargement
                          ? LoadingWidget()
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
