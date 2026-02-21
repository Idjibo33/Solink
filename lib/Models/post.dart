import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String userId;
  String content;
  List likes;
  Timestamp creeLe;
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
