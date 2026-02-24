import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final int comments;
  final List likes;
  final Timestamp creeLe;
  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comments,
    required this.content,
    required this.likes,
    required this.creeLe,
  });
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      comments: map['comments'],
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      content: map['content'],
      likes: map['likes'],
      creeLe: map['creeLe'],
    );
  }
}
