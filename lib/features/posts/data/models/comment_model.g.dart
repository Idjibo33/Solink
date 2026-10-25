// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  content: json['content'] as String,
  creeLe: timestampFromJson(json['creeLe']),
);

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'content': instance.content,
      'creeLe': timestampToJson(instance.creeLe),
    };
