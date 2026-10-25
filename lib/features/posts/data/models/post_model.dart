import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends Equatable {
  const PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.comments,
    required this.likes,
    required this.creeLe,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  final String id;
  final String userId;
  final String userName;
  final String content;
  final int comments;
  @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
  final List<String> likes;
  @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)
  final Timestamp creeLe;

  bool isLikedBy(String userId) => likes.contains(userId);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? content,
    int? comments,
    List<String>? likes,
    Timestamp? creeLe,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      creeLe: creeLe ?? this.creeLe,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    content,
    comments,
    likes,
    creeLe,
  ];
}

List<String> stringListFromJson(Object? value) {
  if (value is! List) {
    return const [];
  }
  return value.map((item) => item.toString()).toList(growable: false);
}

List<String> stringListToJson(List<String> value) => value;
