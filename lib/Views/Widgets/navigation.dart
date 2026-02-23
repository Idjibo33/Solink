import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Navigation/navigation_bar_provider.dart';
import 'package:so_link/Views/Screens/Chats/chats_screen.dart';
import 'package:so_link/Views/Screens/Feed/feed_screen.dart';
import 'package:so_link/Views/Screens/Profil/profil_screen.dart';
import 'package:so_link/constants.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [FeedScreen(), ChatsScreen(), ProfilScreen()];
    return Consumer<NavigationBarProvider>(
      builder: (context, value, child) => Scaffold(
        body: pages.elementAt(value.pageIndex),
        bottomNavigationBar: Consumer<NavigationBarProvider>(
          builder: (context, value, child) => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: titreTexte,
            unselectedLabelStyle: corpsTexte,
            currentIndex: value.pageIndex,
            onTap: (indexValue) => value.naviguer(indexValue),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
              BottomNavigationBarItem(
                icon: Icon(Icons.mark_chat_unread_sharp),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "profil",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
