import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/chat.dart';
import 'package:so_link/Models/gerer_timestamp.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/constants.dart';

class ChatBubble extends StatelessWidget {
  final Chat chat;
  const ChatBubble({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.watch<UtililsateurProvider>().docId;
    bool isMe = chat.senderId == currentUserId;
    String date = gererTimeStamp(chat.envoyeLe ?? Timestamp.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(chat.content, style: titreTexte),
              Text(date, style: corpsTexte),
            ],
          ),
        ),
      ),
    );
  }
}
