import 'package:flutter/material.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';

class ChatWidget extends StatelessWidget {
  final UtilisateurModel user;
  const ChatWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(leading: UserAvatar(size: 24), title: Text(user.nom)),
    );
  }
}
