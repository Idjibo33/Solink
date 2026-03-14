import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/constants.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Machine%20learning/language.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/post_reaction_widget.dart';
import 'package:so_link/Views/Widgets/post_user_infos.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String? translation;
  @override
  void initState() {
    super.initState();
    translation;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              PostUserInfos(post: widget.post),
              Text(widget.post.content),

              translation == null
                  ? Consumer<LanguageProvider>(
                      builder: (context, value, child) => GestureDetector(
                        onTap: () => value
                            .translateLanguage(texte: widget.post.content)
                            .then(
                              (texte) => setState(() {
                                translation = texte;
                              }),
                            ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Traduire",
                              style: corpsTexte.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(translation!, style: corpsTexte),

              PostReactionWidget(post: widget.post),
            ],
          ),
        ),
      ),
    );
  }
}
