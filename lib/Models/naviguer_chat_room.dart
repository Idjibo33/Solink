import 'package:flutter/material.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Views/Screens/Chats/chat_room.dart';

void naviguerChatRoom(
  BuildContext context, {
  required UtilisateurModel receiverInfos,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChatRoom(user: receiverInfos)),
  );
}
