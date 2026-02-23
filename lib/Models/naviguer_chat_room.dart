import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Views/Screens/Chats/chat_room.dart';

void naviguerChatRoom(
  BuildContext context, {
  required UtilisateurModel receiverInfos,
}) {
  if (Platform.isIOS) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ChatRoom(user: receiverInfos)),
    );
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChatRoom(user: receiverInfos)),
  );
}
