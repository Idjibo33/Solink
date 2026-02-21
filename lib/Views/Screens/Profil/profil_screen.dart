import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Views/Screens/Profil/profil_statistique.dart';
import 'package:so_link/Views/Widgets/post_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text("Profile"),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(300),
                child: ProfilStatistique(),
              ),
            ),
            StreamBuilder(
              stream: postsProvider.userPosts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text(snapshot.error.toString())),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }
                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("Aucun document trouvé")),
                  );
                }
                return SliverList.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => PostWidget(
                    post: PostModel(
                      id: snapshot.data![index].id,
                      userId: snapshot.data![index].userId,
                      content: snapshot.data![index].content,
                      creeLe: snapshot.data![index].creeLe,
                      likes: [],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
