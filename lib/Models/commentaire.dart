import 'package:cloud_firestore/cloud_firestore.dart';

class Commentaire {
  String id;
  String content;
  String userId;
  Timestamp creeLe;
  Commentaire({
    required this.id,
    required this.content,
    required this.userId,
    required this.creeLe,
  });
  factory Commentaire.fromMap(Map<String, dynamic> map) {
    return Commentaire(
      id: map['id'],
      content: map['content'],
      userId: map['userId'],
      creeLe: map['creeLe'],
    );
  }
}
