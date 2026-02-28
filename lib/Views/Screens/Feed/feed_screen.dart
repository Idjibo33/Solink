import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/loading_widget.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/Views/Widgets/new_post_1.dart';
import 'package:so_link/Views/Widgets/post_widget.dart';
import 'package:so_link/Models/constants.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostsProvider>();
    final GlobalKey newPostWidget = GlobalKey();
    return Scaffold(
      floatingActionButton: CustomContainer(
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(26),
          ),
          backgroundColor: couleurePrincipale.withValues(alpha: 0.5),
          onPressed: () =>
              Scrollable.ensureVisible(newPostWidget.currentContext!),
          child: Icon(Icons.create, color: Colors.white),
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: FittedBox(
                child: Row(
                  children: [
                    LogoWidget(padding: 8, size: 18),
                    Text(
                      "SoLink",
                      style: enteteTexte.copyWith(
                        color: couleurePrincipale,
                        fontSize: 25,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
              floating: true,
              snap: true,
            ),
            SliverToBoxAdapter(
              key: newPostWidget,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 12,
                ),
                child: NewPost1(),
              ),
            ),
            StreamBuilder(
              stream: postProvider.posts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text(snapshot.error.toString())),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(child: LoadingWidget());
                }
                if (snapshot.hasData && snapshot.data == null) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("Aucun post trouvé")),
                  );
                }
                return SliverList.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      PostWidget(post: snapshot.data![index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
