import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Auth/deconnexion_provider.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/Views/Widgets/new_post_1.dart';
import 'package:so_link/Views/Widgets/post_widget.dart';
import 'package:so_link/constants.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomContainer(
        children: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(26),
          ),
          backgroundColor: couleurePrincipale.withValues(alpha: 0.5),
          onPressed: () => context
              .read<DeconnexionProvider>()
              .deconnecterUtilisateur(context),
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
                    LogoWidget(padding: 8, size: 16),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 12,
                ),
                child: NewPost1(),
              ),
            ),
            SliverList.builder(itemBuilder: (context, index) => PostWidget()),
          ],
        ),
      ),
    );
  }
}
/* RefreshIndicator(
        onRefresh: () => Future.delayed(Duration(seconds: 2)),
        child: Column(
          children: [
            NewPost1(),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => PostWidget(),
              ),
            ),
          ],
        ),
      )*/