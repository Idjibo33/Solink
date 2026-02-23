import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String senderId;
  final String content;
  final Timestamp? envoyeLe;
  Chat({required this.senderId, required this.content, required this.envoyeLe});
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      senderId: map['senderId'],
      content: map['content'],
      envoyeLe: map['envoyeLe'],
    );
  }
}
