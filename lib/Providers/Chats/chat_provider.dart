import 'package:flutter/material.dart';
import 'package:so_link/Models/chat.dart';
import 'package:so_link/Services/Firebase/Firestore/chats.dart';

class ChatProvider extends ChangeNotifier {
  final _chatservices = Chats();
  // Envoyer message
  Future? sendChat({
    required String content,
    required String receiverId,
    required String senderid,
  }) async {
    try {
      await _chatservices.sendChat(
        content: content,
        receiverId: receiverId,
        senderId: senderid,
      );
    } catch (e) {
      return null;
    }
  }

  // Lire les messages
  Stream<List<Chat>>? readChats({
    required String receiverId,
    required String senderId,
  }) {
    try {
      return _chatservices.getChats(receiverId: receiverId, senderId: senderId);
    } catch (e) {
      return null;
    }
  }
}
