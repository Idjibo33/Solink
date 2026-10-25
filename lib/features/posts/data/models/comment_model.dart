import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel extends Equatable {
  const CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.creeLe,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  final String id;
  final String userId;
  final String userName;
  final String content;
  @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)
  final Timestamp creeLe;

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  @override
  List<Object?> get props => [id, userId, userName, content, creeLe];
}
