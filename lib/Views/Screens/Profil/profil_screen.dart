import 'package:flutter/material.dart';
import 'package:so_link/Views/Screens/Profil/profil_statistique.dart';
import 'package:so_link/Views/Widgets/bouton_secondaire.dart';
import 'package:so_link/Views/Widgets/post_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text("Profile"),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(220),
              child: ProfilStatistique(),
            ),
          ),

          SliverList.builder(itemBuilder: (context, index) => PostWidget()),
        ],
      ),
    );
  }
}
