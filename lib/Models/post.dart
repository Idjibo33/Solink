import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String content;
  final List likes;
  final Timestamp creeLe;
  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.likes,
    required this.creeLe,
  });
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      userId: map['userId'],
      content: map['content'],
      likes: map['likes'],
      creeLe: map['creeLe'],
    );
  }
}
