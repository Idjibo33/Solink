import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Providers/Auth/deconnexion_provider.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Screens/Profil/profil_statistique.dart';
import 'package:so_link/Views/Widgets/loading_widget.dart';
import 'package:so_link/Views/Widgets/post_widget.dart';
import 'package:so_link/Models/constants.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();
    final user = context.watch<UtililsateurProvider>().id;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text("Profile"),
              actions: [
                Consumer<DeconnexionProvider>(
                  builder: (context, value, child) => IconButton(
                    onPressed: () => value.deconnecterUtilisateur(),
                    icon: Icon(Icons.logout),
                  ),
                ),
                Gap(8),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(300),
                child: ProfilStatistique(),
              ),
            ),
            StreamBuilder(
              stream: postsProvider.getUserPosts(
                userId: user!,
                context: context,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text(snapshot.error.toString())),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(child: LoadingWidget());
                }
                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("Aucun document trouvé", style: corpsTexte),
                    ),
                  );
                }
                return SliverList.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => PostWidget(
                    post: PostModel(
                      comments: snapshot.data![index].comments,
                      userName: snapshot.data![index].userName,
                      id: snapshot.data![index].id,
                      userId: snapshot.data![index].userId,
                      content: snapshot.data![index].content,
                      creeLe: snapshot.data![index].creeLe,
                      likes: snapshot.data![index].likes,
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
