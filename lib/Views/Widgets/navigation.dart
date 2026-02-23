import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Navigation/navigation_bar_provider.dart';
import 'package:so_link/Views/Screens/Chats/chats_screen.dart';
import 'package:so_link/Views/Screens/Feed/feed_screen.dart';
import 'package:so_link/Views/Screens/Profil/profil_screen.dart';
import 'package:so_link/constants.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  List<Widget> pages = [FeedScreen(), ChatsScreen(), ProfilScreen()];
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(pageIndex),
      bottomNavigationBar: Consumer<NavigationBarProvider>(
        builder: (context, value, child) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: titreTexte,
          unselectedLabelStyle: corpsTexte,
          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
            BottomNavigationBarItem(
              icon: Icon(Icons.mark_chat_unread_sharp),
              label: "Chats",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "profil"),
          ],
        ),
      ),
    );
  }
}
