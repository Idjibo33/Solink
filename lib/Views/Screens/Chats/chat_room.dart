import 'package:flutter/material.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class ChatRoom extends StatelessWidget {
  final UtilisateurModel user;
  const ChatRoom({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            UserAvatar(size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.nom, style: titreTexte),
                Text(user.email, style: corpsTexte),
              ],
            ),
          ],
        ),
      ),
      body: Column(),
    );
  }
}
